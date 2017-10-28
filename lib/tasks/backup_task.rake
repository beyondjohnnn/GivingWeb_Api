# lib/tasks/db.rake

# TODO when in production confirm this still works as expected

require_relative './../backup_helper'
# File.directory?(directory)

DATABASE_NAME = "givingweb_api_development"
BACKUP_DIR = "#{File.expand_path(File.dirname(__FILE__))}/../../db/backup/"

backup_helper = BackUpHelper.new(BACKUP_DIR)
FILE_LOCATION = backup_helper.get_backup_file_name()
LOG_LOCATION = backup_helper.get_log_file_name()

namespace :db do

  task :dump => :environment do
    puts "Backup made at #{backup_helper.backup_time}"
    system("pg_dump #{DATABASE_NAME} > #{FILE_LOCATION}.sql")
  end

  task :dump_zip => :environment do
    puts "Zipped backup made at #{backup_helper.backup_time}"
    system("pg_dump #{DATABASE_NAME} | gzip > #{FILE_LOCATION}.gz")
  end

  task :restore => :environment do
    system("psql #{DATABASE_NAME} < #{FILE_LOCATION}.sql")
  end

  task :restore_zip => :environment do
    system("gunzip -c #{FILE_LOCATION}.gz | psql #{DATABASE_NAME}")
  end

end
