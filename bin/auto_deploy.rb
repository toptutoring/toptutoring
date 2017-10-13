require 'date'
require 'english'

class DeploymentError < StandardError
  attr_reader :error
  def initialize(error, msg = "Deployment Error")
    @error = error
    super(msg)
  end
end

class Deployer
  TTUTORING_PATH = "INSTALL_TTUTORING_PATH".freeze
  PATH_COMMAND = "cd #{TTUTORING_PATH}".freeze
  TERMINAL_NOTIFIER = "INSTALL_TERMINAL_NOTIFIER_PATH".freeze
  BRANCH_NAME = "add-korean-daily-ad-page".freeze

  def process
    checkout_to_deploy_branch
    set_dates
    deploy
    return_to_user_branch
  rescue DeploymentError => e
    notify e.message + ": " + e.error
  end

  private

  def checkout_to_deploy_branch
    if working_tree_clean?
      set_user_branch
      `#{PATH_COMMAND} && git checkout #{BRANCH_NAME} && git pull`
      raise DeploymentError.new("Could not switch to #{BRANCH_NAME} branch") if shell_error
    else
      raise DeploymentError.new("Current branch is not clean. Unable to process.")
    end
  end

  def working_tree_clean?
    `#{PATH_COMMAND} && git status` =~ /working tree clean/
  end

  def set_user_branch
    branch_list = `#{PATH_COMMAND} && git branch`
    @user_branch = branch_list.match(/\*\s+(.+)\n/)[1]
  end

  def return_to_user_branch
    `#{PATH_COMMAND} && git checkout #{@user_branch}`
  end

  def set_dates
    log_message = `#{PATH_COMMAND} && git log -1`
    date_string = log_message.split("\n").find { |string| string.match("Date:   ") }
    @last_update = Date.parse date_string
    @today = Date.today
  end

  def deploy
    if needs_deployment?
      execute_deployment
      notify deployment_message
    else
      notify no_deployment_message
    end
  end

  def needs_deployment?
    return false if @last_update == @today
    ttutoring_posts_dir = Dir.new(TTUTORING_PATH + "/_posts")
    grab_posts_to_publish(ttutoring_posts_dir)
    STDOUT.puts @posts_to_publish
    @posts_to_publish.any?
  end

  def grab_posts_to_publish(dir)
    @posts_to_publish = []
    dir.each do |file|
      match = file.match(/(\d+-\d+-\d+).+/)
      next unless match
      date = Date.parse(match[1])
      @posts_to_publish << match[0] if date.between?(@last_update, @today)
    end
  end

  def execute_deployment
    commit_args = "--allow-empty -m 'Publishing article(s): #{@posts_to_publish.join(', ')}'"
    @git_log = `#{PATH_COMMAND} && git commit #{commit_args} && git push`
    raise DeploymentError.new("Failure while pushing to #{BRANCH_NAME}") if shell_error
  end

  def deployment_message
    publish_count = @posts_to_publish.count
    if publish_count > 1
      publish_message = "#{publish_count} articles. Check commit for details."
    else
      publish_message = @posts_to_publish[0]
    end
    "Auto-deployed. Published #{publish_message}"
  end

  def no_deployment_message
    "Skipped auto-deploy since there were no posts to publish."
  end

  def notify(message)
    `#{TERMINAL_NOTIFIER} -title 'TopTutoring' -message '#{message}'`
  end

  def shell_error
    $CHILD_STATUS.exitstatus != 0
  end
end

deployer = Deployer.new
deployer.process
