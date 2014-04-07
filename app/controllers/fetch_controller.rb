require 'open-uri'
require 'zlib'
require 'yajl'

# archive_url = 'http://data.githubarchive.org/2014-01-01-0.json.gz'

class FetchController < ApplicationController

  def index
    # Bind the form to the fetch model
    @fetch = Fetch.new
  end

  def create
    # make sure the URL is valid

    # This url has to be in a specific format to work corectly with open_uri
    # tokenize it to get the date only then rebuild url and loop with a range
    # to get all the times.

    # it may be better to just have the user specify the date
    # and have the code automatically resolve the ULR, then there
    # is less chance of errors
    archive_url = params[:fetch][:archive_url]

    # hard code based on expected conventions
    domain = archive_url[0..29]
    format = archive_url[-8..-1]

    if domain === "http://data.githubarchive.org/" &&
       format === ".json.gz"

      # get the date only
      match = /(\d{4}-\d{2}-\d{2})/.match(archive_url)
      if match
        date = match[0]

        # First, get a list of urls
        # for each hour of the specified day
        urls = []
        #TODO: temp set to one hour for testing, change back to 23 when done
        (0..1).each do | hr |
          new_url = domain + date + "-" + hr.to_s + format
          urls.append( new_url )
        end

        # record data
        # this could take a while since one full day
        # can have thousands of entries
        puts "Got urls: ", urls
        record_data( urls )

      else
        #TODO: change puts to proper flash messages - ok for now
        puts "Proper date not specified. Unable to get archive data."
        puts "Convention: yyyy-mm-dd"
      end

    else
      puts "Invalid URL for github Archive."
      puts "Convention: 'http://data.githubarchive.org/2014-01-01.json.gz'\n"
    end

    redirect_to root_path
  end


  # TODO: move this to a utility file - ok for now
  def record_data( urls )
    skipped_urls = []
    item_count = 0
    urls.each do | url |
      puts "\n\nGetting archive data for [" + url +"]:"

      gz = open( url )
      data = Zlib::GzipReader.new(gz).read

      Yajl::Parser.parse(data) do | dat |
        #TODO: add testing and error handling
        begin
          created_at  = dat['created_at']
          event_type  = dat['type']

          # skip "GistEvent"
          # these seem to have a lot of nil values
          next if event_type === "GistEvent"

          # skip items with no repo since they
          # can not be displayed on report
          next if dat['repository'] === nil

          repo_name   = dat['repository']['name']
          repo_url    = dat['repository']['url']
          event_count = 0

          # payloads have different information
          # only get count for PushEvent
          if event_type === "PushEvent"
            event_count = dat['payload']['size']
          end


          # get the corresponding report based on the event type
          # TODO: optimize this so it's not doing a look up for each fetch
          # maybe create a hash for quick look up???
          report = Report.where(event: event_type).first

          # TODO: add error checking to make sure I got a report

          # add needed data to data base
          # not sure why we need to models, so just add to report model
          Fetch.create(
            date:    created_at,
            count:   event_count,
            name:    repo_name,
            url:     repo_url,
            report:  report
          )

          puts "date: "        + created_at.to_s
          puts "event_type: "  + event_type
          puts "repo_name: "   + repo_name
          puts "repo_url: "    + repo_url
          puts "event_count: " + event_count.to_s
          puts "\n\n"

          item_count += 1
        rescue
          # caught error with dat...
          # go to the next data set
          # temp capture in variable for testing
          skipped_urls.append(dat)
          next
        end
      end
    end

    puts "\nGot [" + item_count.to_s + "] entries"
    if skipped_urls.length > 0
      puts "Caught error for hte following urls: "
      puts skipped_urls
    end
  end

end