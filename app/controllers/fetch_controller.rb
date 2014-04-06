require 'open-uri'
require 'zlib'

class FetchController < ApplicationController

  def index
    # Bind the form on the side bar to the registrant model
    #@registrant = Registrant.new
  end

  def create
    # get data for specified date (default to 2014-01-01)
    gz = open('http://data.githubarchive.org/2014-01-01-{0..23}.json.gz')
  end

end