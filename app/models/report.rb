class Report < ModelBase
  include Mongoid::Document

  attr_accessor :datetime, :starttime, :endtime

  # create report based on event types
  field :event,   type: String  # event type

  has_many :fetches
end