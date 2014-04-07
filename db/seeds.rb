Report.destroy_all

events = [
  'CommitCommentEvent',
  'CreateEvent',
  'DeleteEvent',
  'DeploymentEvent',
  'DeploymentStatusEvent',
  'DownloadEvent',
  'FollowEvent',
  'ForkEvent',
  'ForkApplyEvent',
  'GistEvent',
  'GollumEvent',
  'IssueCommentEvent',
  'IssuesEvent',
  'MemberEvent',
  'PageBuildEvent',
  'PublicEvent',
  'PullRequestEvent',
  'PullRequestReviewCommentEvent',
  'PushEvent',
  'ReleaseEvent',
  'StatusEvent',
  'TeamAddEvent',
  'WatchEvent'
]

events.each do | event |
  Report.create( event: event )
end
