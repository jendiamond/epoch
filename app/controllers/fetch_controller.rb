class FetchController < ApplicationController

  def index
    # Bind the form to the fetch model
    @fetch = Fetch.new
  end

  def create
    #temp range for testing
    range = (0..23)
    archive_url = params[:fetch][:archive_url]

    puts "\n\narchive_url='"+archive_url+"'"

    # get tne URLS for each hour in the range
    urls = urls_by_hour_resolve( archive_url, range )

    if urls.length > 0
      fetch_data( urls )

      # TODO: add something here to user a report is ready
    else
      #TODO - convert to proper flash message
      puts "\n\nInvalid URL for github Archive."
      puts "Convention: 'http://data.githubarchive.org/2014-01-01.json.gz'\n\n"
    end
    redirect_to root_path
  end

end