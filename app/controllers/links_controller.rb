class LinksController < ApplicationController

  # def new
  # end

  def index
    @report = Report.new

    # subtract on from hrs - showing 12pm and 1pm
    @data = report_top_repos(25,11,12)
    @hours = hours_list
   end

  # def show
  # end
  #
  # def edit
  # end

  def create
    # there should be a better way to do this
    # so I don't have to rebuild the entire page

    puts "\n\nGot Params", params

    # get date and hours, shift hours by 1

    @data = report_top_repos(25,1,0)
    redirect_to links_path
  end

  # def update
  # end
  #
  # def destroy
  # end

end