class Report < ModelBase
  include Mongoid::Document

  # create report based on event types
  field :event,   type: String  # event type

  has_many :fetches
end