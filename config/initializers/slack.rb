class NoOpHTTPClient
  def self.post uri, params={}
    params_array = params[:payload].split(',')
    channel, username, message = params_array.map { |s| s.split(':')[1] }
    Rails.logger.info "SLACK Notifier\n" \
                      "--> Channel: #{channel}" \
                      "\n--> Posting As: #{username}" \
                      "\n--> Message: #{message}\n"
  end
end

SLACK_NOTIFIER = Slack::Notifier.new ENV.fetch('SLACK_WEBHOOK_URL') do
  http_client NoOpHTTPClient if Rails.env.test? || Rails.env.development?
  defaults channel: ENV.fetch('SLACK_DEFAULT_CHANNEL'),
           username: "toptutoring-notifier"
end
