namespace :release do
  desc <<-DESC.strip_heredoc
     This updates the sitemap for production using the sitemap_generator gem

      Examples:
      rake 'release:update_sitemap'
  DESC

  task :update_sitemap do
    if (ENV["DWOLLA_ENVIRONMENT"] == "production") && Rails.env.production?
      STDOUT.puts "#{Time.current} - Updating site map for production."
      Rake::Task["sitemap:refresh"].invoke 
    else
      STDOUT.puts "#{Time.current} - Not on production. Update for site map cancelled."
    end
  end
end
