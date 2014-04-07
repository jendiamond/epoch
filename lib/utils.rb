require 'open-uri'
require 'zlib'
require 'yajl'

# check if in dev mode
Rails.env === 'development' ? $dev_mode = true : $dev_mode = false

def db_destroy()
  Fetch.destroy_all
  Report.destroy_all
  puts "Database is clean..."
end

# Pre Create reports, based on known event types
def reports_create()
  if $dev_mode
    puts 'Creating reports...'
  end

  Report.destroy_all

  # it would be great if the api allowed us to get this
  # list so it does not have to be hardcoded...
  [
    'CommitCommentEvent',
    'CreateEvent',
    'DeleteEvent',
    'DeploymentEvent',
    'DeploymentStatusEvent',
    'DownloadEvent',
    'FollowEvent',
    'ForkEvent',
    'ForkApplyEvent',
    'GistEvent',
    'GollumEvent',
    'IssueCommentEvent',
    'IssuesEvent',
    'MemberEvent',
    'PageBuildEvent',
    'PublicEvent',
    'PullRequestEvent',
    'PullRequestReviewCommentEvent',
    'PushEvent',
    'ReleaseEvent',
    'StatusEvent',
    'TeamAddEvent',
    'WatchEvent'
  ].each do | event |
    Report.create( event: event )
  end
end

def urls_by_hour_resolve( url, range=(0..23) )
  # This url has to be in a specific format to work corectly with open_uri
  # tokenize it to get the date only then rebuild url and loop with a range
  # to get all the times.

  # it may be better to just have the user specify the date
  # and have the code automatically resolve the ULR, then there
  # is less chance of errors

  # hard code based on expected conventions
  domain = url[0..29]
  format = url[-8..-1]

  urls = []
  if domain === "http://data.githubarchive.org/" &&
      format === ".json.gz"

    # get the date only
    match = /(\d{4}-\d{2}-\d{2})/.match(url)
    if match
      range.each do | hr |
        urls.append( domain + match[0] + "-" + hr.to_s + format )
      end
    else
      #TODO: add proper messages for users
      if $dev_mode
        puts "Proper date not specified. Unable to get archive data."
        puts "Convention: yyyy-mm-dd"
      end
    end

  end

  # return the urls
  urls
end

# url = 'http://data.githubarchive.org/2014-01-01-0.json.gz'
def fetch_data( urls )
  if urls.length
    # TODO: I'll need a way to keep track of which days have been entered

    # if reports don't' exist, create them
    reports_create if Report.list.length < 1

    skipped_urls = []
    item_count = 0
    urls.each do | url |

      if $dev_mode
        puts "\n\nGetting archive data for [" + url +"]:"
      end

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

          if $dev_mode
            puts "date: "        + created_at.to_s
            puts "event_type: "  + event_type
            puts "repo_name: "   + repo_name
            puts "repo_url: "    + repo_url
            puts "event_count: " + event_count.to_s
            puts "\n\n"
          end

          item_count += 1
        rescue
          # caught error, go to the next data set
          # temp capture in variable for testing
          skipped_urls.append(dat)
          next
        end
      end
    end

    if $dev_mode
      puts "\nCreated [" + item_count.to_s + "] archive entries"
      if skipped_urls.length > 0
        puts "Caught error for hte following urls: "
        puts skipped_urls
      end
    end
  end
end

def reports_list()
  Report.distinct(:event)
end

def report_get(event, date, hour)
  puts "Get data for ", event, date, hour

  # get the report
  report = Report.where( event: event ).first

  # get the "fetches" based on the date and time

end

