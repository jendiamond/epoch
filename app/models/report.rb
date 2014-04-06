class Report < ModelBase
  include Mongoid::Document
  include Mongoid::Timestamps

  # only collect needed data for report
  # to keep database as small as possible
  field :created_at,  type: Time    # event date/time
  field :type,        type: String  # event type
  field :count,       type: Integer # event count, how may of certain event type
  field :name,        type: String  # repository name
  field :url,         type: String  # repository url

end