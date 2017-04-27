namespace :data do
  require 'csv'
  require 'open-uri'

  desc <<-DESC.strip_heredoc
     This populates the subjects based upon a local or remote CSV file.

      Examples:
      rake data:populate_subjects[path/to/local/file.csv]
      rake data:populate_subjects[http://example.com/some.csv]
  DESC

  task :populate_subjects, [:csv_url] => [:environment] do |_, args|
    if args[:csv_url].present?
      CSV.parse(open(args[:csv_url]), row_sep: :auto, headers: :first_row) do |csv|
        title = csv["Name"].strip
        STDOUT.puts("Creating the subject: #{title}..."
                    Subject.create!(name: title)
      end
      STDOUT.puts("Finished creating subjects for #{args[:csv_url]}")
    else
      STDERR.puts("A CSV path is required. Run rake 'data:populate_subjects[CSV_URL]' where CSV_URL is the url of the CSV file")
    end
  end
end

