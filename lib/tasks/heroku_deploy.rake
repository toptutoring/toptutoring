namespace :heroku do
  desc <<-DESC.strip_heredoc
    This promotes toptutoring-staging to production and checks for matches in config vars.

    This optionally takes staging and prod variables if one wishes to promote another pipeline.
    Examples:
      rake  heroku:deploy
      rake  heroku:deploy[toptutoring-staging-2 toptutoring-2]

    The first command will promote toptutoring-staging to toptutoring
    The second command will promote toptutoring-staging2 to toptutoring-2
  DESC
  task :deploy, [:staging_app, :prod_app] => [:environment] do |_, args|
    include Spinner
    staging = args[:staging_app] || 'toptutoring-staging'
    prod = args[:prod_app] || 'toptutoring'

    threads = []
    thread = Thread.new do
      config_match = system("bin/check_heroku_configs.sh #{staging} #{prod}")
      if config_match
        STDOUT.puts "\r Promoting #{staging}...\n"
        if system("heroku pipelines:promote --app #{staging} && heroku run rake db:migrate --app #{prod}")
          STDOUT.puts "\r \e[32m Successfully deployed #{staging} to #{prod}!\e[0m"
        else
          STDERR.puts "\r \e[31m Errors promoting #{staging} \n\e[0m"
        end
      else
        STDERR.puts "\r \e[31m Please compare the config vars between the environments. \n\e[0m"
      end
    end

    spin_it(10) while thread.alive?
    thread.join
    STDOUT.puts "\n   Deployment task complete"
  end
end
