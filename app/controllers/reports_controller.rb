class ReportsController < ApplicationController

  def index
    @time = (0..23)
    @reports = reports_list
  end

  def show
  end

  def new
    # Bind the form to the report model
    @report = Report.new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

end