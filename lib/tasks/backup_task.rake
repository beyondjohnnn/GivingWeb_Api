# lib/tasks/db.rake

# TODO when in production confirm this still works as expected

require_relative './../backup_helper'
require_relative './../database_logger'

DATABASE_NAME = "givingweb_api_development"
BACKUP_DIR = "#{File.expand_path(File.dirname(__FILE__))}/../../db/backup/"

backup_helper = BackUpHelper.new(DATABASE_NAME, BACKUP_DIR)
FILE_LOCATION = backup_helper.get_backup_file_name()
LOG_LOCATION = backup_helper.get_log_file_name()

namespace :db do

  task :dump => :environment do
    puts "Backup made at #{backup_helper.backup_time}"
    backup_helper.make_backup()
  end

  task :dump_zip => :environment do
    puts "Zipped backup made at #{backup_helper.backup_time}"
    backup_helper.make_zipped_backup()
  end
end
