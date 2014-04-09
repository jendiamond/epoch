class LinksController < ApplicationController

  def index
    @report = Report.new

    # subtract on from hrs - showing 12pm and 1pm
    @data = report_top_repos(25,11,12)
    @hours = hours_list
   end

  def refresh
    # get date and hours, shift hours by 1

    puts "\n\nGOT PARAMS#{params.to_s}\n\n"

    # shift time by one by one to account of 0 index of archive data
    date       = params[:date]
    start_time = params[:start_time].to_i - 1
    end_time   = params[:end_time].to_i - 1
    event      = 'PushEvent'
    @data = report_top_repos( 25, start_time, end_time, date, event )

    puts "Getting report for: ", start_time, end_time, date, event



    # For AJAX request
    render json: @data
  end

end