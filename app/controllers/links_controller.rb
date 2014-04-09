class LinksController < ApplicationController

  def index
    @report = Report.new

    # subtract one from hrs - showing 12pm and 1pm
    @data = report_top_repos(25,11,12)

    @events = events_list
    @dates  = dates_list
    @hours  = hours_list
   end

  def refresh
    # shift time by one by one to account of 0 index of archive data
    # not all event types have been tested...
    event      = params[:event].strip
    date       = params[:date].strip
    start_time = params[:start_time].to_i - 1
    end_time   = params[:end_time].to_i - 1
    @data = report_top_repos( 25, start_time, end_time, date, event )

    puts "Getting report for: ", start_time, end_time, date, event

    # For AJAX request
    render json: @data
  end

end