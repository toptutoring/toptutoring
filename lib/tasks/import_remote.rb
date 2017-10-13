  require 'open3'
  require 'English'

  module ProgressDisplayer
    MARKERS = {
     "pg_dump: reading default privileges" => 1,
     "pg_dump: reading indexes" => 2,
     "pg_dump: reading constraints" => 3,
     "pg_dump: reading policies" => 4,
     "pg_dump: reading dependency data" => 5,
     "pg_restore: connecting to database for restore" => 6,
     "pg_dump: dumping contents of table \"public.users\"" => 7,
     "pg_restore: setting owner and privileges for SCHEMA \"public\"" => 8,
     "pg_restore: setting owner and privileges for TABLE DATA \"public.users\"" => 9
    }

    BAR = {
      0 => "[..........................] (0%) Importing Staging",
      1 => "[##........................] (10%) Importing Staging",
      2 => "[####......................] (20%) Importing Staging",
      3 => "[######....................] (30%) Importing Staging",
      4 => "[########..................] (40%) Importing Staging",
      5 => "[##########................] (50%) Importing Staging",
      6 => "[############..............] (60%) Importing Staging",
      7 => "[###############...........] (70%) Importing Staging",
      8 => "[####################......] (80%) Importing Staging",
      9 => "[#######################...] (90%) Importing Staging",
      10 => "\b\b\e[32m*\e[0m [##########################] (100%) Importing Staging - Done!",
    }

    def current_progress(line, percentage)
     MARKERS[line] || percentage 
    end

    def progress_bar_output(percentage, first = false)
      bar = "\r\e[32m" + pinwheel.rotate!.first + "\e[0m " + BAR[percentage]
      bar.strip! if first
      STDOUT.print bar
    end

    def pinwheel
      @pinwheel ||= %w(| / - \\)
    end
  end

  class DatabaseUpdateError < StandardError
    attr_reader :error
    ERROR = {
      no_remote: "The remote you are requesting is unavailable.",
      development: "Environment is not development.",
      no_app_access: "You do not have access to the current remote database.\n" \
      "Please make sure that the app you want to import is in your Heroku apps list before continuing.",
      drop: "Unable to drop development database.",
      import_data: "Unable to import data from staging backup file.",
      migrate: "Unable to fully migrate. Try: \"rails db:migrate\".",
      set_passwords: "Unable to set passwords"
    }.freeze

    def initialize(error, message = "Failed to restore staging data.")
      @error = ERROR[error]
      super(message)
    end
  end

  class RemoteDataImporter
    include ProgressDisplayer
    CHECK = "\e[32m✔\e[0m".freeze

    def initialize(remote)
      @app_name = remote
      @password = ENV.fetch('DEFAULT_DEV_RESTORE_PASSWORD')
    end

    def restore
      disconnect_and_drop if restorable?
      pull_staging
      migrate
      set_passwords
      success_message 
  rescue DatabaseUpdateError => e
    display e.message + ' ' + e.error
    exit 1
  end

  private

  def display(message)
    system("echo #{ message }")
  end

  def restorable?
    display "Checking for #{@app_name} app in Heroku Apps List."
    raise_error(:no_app_access) unless run_process("heroku apps | grep \"#{@app_name}\"")
    display "#{CHECK} Found #{@app_name}." 
    display "Checking if running on development environment."
    raise_error(:development) unless Rails.env.development?
    display "#{CHECK} Running on development."
    true
  end

  def disconnect_and_drop
    display "Checking if top_tutoring_development db exists locally."
    if run_process("psql -l | grep top_tutoring_development")
      display "#{CHECK} Database found."
      display "Disconnecting and dropping database."
      ActiveRecord::Base.connection.disconnect!
      raise_error(:drop) unless system("dropdb top_tutoring_development")
      display "#{CHECK} Successfully dropped development database."
    else
      display "Database does not exist. Skipping drop. Creating testing database."
      system("psql -l | grep top_tutoring_test || createdb top_tutoring_test")
    end
  end

  def pull_staging
    display "Importing staging database."
    raise_error(:import_data) unless run_process("heroku pg:pull DATABASE_URL top_tutoring_development --app #{@app_name}", true)
    display "#{CHECK} Successfully imported staging database."
  end

  def migrate
    display "Performing migrations."
    raise_error(:migrate) unless run_process("rails db:migrate")
    display "#{CHECK} Successfully performed migrations"
  end

  def set_passwords
    display "Setting user passwords."
    password_change_script = "User.all.each { |user| user.password = '#{@password}'; user.save }"
    raise_error(:set_passwords) unless run_process("rails runner \"#{password_change_script}\"")
    display "#{CHECK} Successfully reset passwords"
  end

  def raise_error(message)
    raise DatabaseUpdateError.new(message)
  end

  def run_process(cmd, progress = false)
    stdin, stdout, stderr, thread = Open3.popen3(cmd)
    stdin.close
    print_progress_bar(stderr) if progress
    status = thread.value
    stdout.close
    stderr.close
    status.success?
  end

  def print_progress_bar(stderr)
    percentage = 0
    progress_bar_output(percentage, true)
    until (line = stderr.gets).nil? do
      percentage = current_progress(line.chomp, percentage)
      progress_bar_output(percentage)
    end
    progress_bar_output(10)
    system("echo")
  end

  def success_message
    display "Staging successfully imported."
    display "All user passwords were set to \e[93m\"#{@password}\"\e[0m."
  end
end
