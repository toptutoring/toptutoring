SLACK_NOTIFIER = Slack::Notifier.new ENV.fetch('SLACK_WEBHOOK_URL') do
  defaults username: "toptutoring-notifier"
end
