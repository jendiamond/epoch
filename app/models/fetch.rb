class Fetch < ModelBase
  include Mongoid::Document

  attr_accessor :archive_url

  # only collect needed data for report
  # to keep database as small as possible
  # associate the eventType with the report
  field :datetime,    type: String  # event date/time
  field :datesecs,    type: Integer # event date/time converted to seconds
  field :count,       type: Integer # event count, how may of certain event type
  field :name,        type: String  # repository name
  field :url,         type: String  # repository url

  belongs_to :report, autosave: true
end
