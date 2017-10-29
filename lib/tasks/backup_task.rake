# lib/tasks/db.rake

# TODO when in production confirm this still works as expected

currentFile = File.expand_path(File.dirname(__FILE__))
file_location = "#{currentFile}/../../db/dump.sql"
zip_file_location = "#{currentFile}/../../db/dump.gz"

namespace :db do

  task :dump => :environment do
    system("pg_dump givingweb_api_development > #{file_location}")
  end

  task :dump_zip => :environment do
    system("pg_dump givingweb_api_development | gzip > #{zip_file_location}")
  end

  task :restore => :environment do
    system("psql givingweb_api_development < #{file_location}")
  end

  task :restore_zip => :environment do
    system("gunzip -c #{zip_file_location} | psql givingweb_api_development")
  end

end

# use with great discretion ```bundle exec rake db:rebuild```
