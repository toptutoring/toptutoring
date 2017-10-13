require 'benchmark'
require_relative 'import_remote'

namespace :db do
  desc <<-DESC.strip_heredoc
    Wipes current development database and imports remote database.

    This task imports a remote database to the development database.
    It fetches the password from the .env file. Therefore, the user can set the preferred password into there local .env.development file.
    Without arguments, this task imports the data in toptutoring-staging.
    Other remote databases might become available in the future.

    For instance:
    rake 'db:import_remote'
    Will import toptutoring-staging by default.
    If env var DEFAULT_DEV_RESTORE_PASSWORD is set to "my_other_password", passwords will not default to "password" and set to "my_other_password."

    rake 'db:import_remote[app_name]'
    Where app_name is the app where you want to import from.
    Must be in the Heroku Apps List.
    Explicitly tells the task to import from the app_name database.
  DESC

  task :import_remote, [:remote] => [:environment] do |_, args|
    time = Benchmark.realtime do
      env = args[:remote] || 'toptutoring-staging'
      importer = RemoteDataImporter.new(env)
      importer.restore
    end
    system("echo \"Total time: #{time.round(2)} seconds.\"")
  end
end
