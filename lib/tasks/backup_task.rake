# lib/tasks/db.rake

# TODO when in production confirm this still works as expected

require_relative './backup_helper'
# File.directory?(directory)

DATABASE_NAME = "givingweb_api_development"
BACKUP_DIR = "#{File.expand_path(File.dirname(__FILE__))}/../../db/backup/"

backupHelper = BackUpHelper.new(BACKUP_DIR)
FILE_LOCATION = backupHelper.getBackupPath()

namespace :db do

  task :dump => :environment do
    system("pg_dump #{DATABASE_NAME} > #{FILE_LOCATION}.sql")
  end

  task :dump_zip => :environment do
    system("pg_dump #{DATABASE_NAME} | gzip > #{FILE_LOCATION}.gz")
  end

  task :restore => :environment do
    system("psql #{DATABASE_NAME} < #{FILE_LOCATION}.sql")
  end

  task :restore_zip => :environment do
    system("gunzip -c #{FILE_LOCATION}.gz | psql #{DATABASE_NAME}")
  end

end
