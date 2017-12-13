require 'benchmark'
require 'optparse'
require_relative 'import_remote'

namespace :db do
  desc <<-DESC.strip_heredoc
    Wipes current development database and imports remote database.

    This task imports a remote database to the development database.
    It fetches the password from the .env file. Therefore, the user can set the preferred password into there local .env.development file.
    Without arguments, this task imports the data in toptutoring-staging.
    Other remote databases might become available in the future.

    Usage: 
    rake 'db:import_remote[app_name] -- [options]'
    -p Sets password ex. -pMyPassword sets default password for all users to MyPassword
    -s Skips migration

    Examples:
    rake 'db:import_remote'
    Will import toptutoring-staging by default.

    rake 'db:import_remote[app_name]'
    Where app_name is the app where you want to import from.
    Must be in the Heroku Apps List.
    Explicitly tells the task to import from the app_name database.
  DESC

  task :import_remote, [:remote] => [:environment] do |_, args|
    options = {}
    opts = OptionParser.new
    opts.banner = "Usage: rake db:import_remote[remote] -- [options]"
    opts.on("-s", "--skip-migrations", "Skip migrations") { |migrate| options[:skip_migration] = true }
    opts.on("-pPASSWORD", "--password PASSWORD", "Set password") { |password| options[:password] = password }
    user_args = opts.order!(ARGV) {}
    opts.parse!(user_args)

    time = Benchmark.realtime do
      env = args[:remote] || 'toptutoring-staging'
      password = options[:password] || "password"
      importer = RemoteDataImporter.new(env, password, options[:skip_migration])
      importer.restore
    end
    system("echo \"Total time: #{time.round(2)} seconds.\"")
  end
end
