require 'fileutils'

class BackUpHelper

  attr_reader :directory, :backup_time, :folder

  def initialize(database, target_directory)
    @database = database
    @directory = target_directory
    @backup_time = get_time()
    @folder = "#{@directory}backup-#{@backup_time}/"
  end

  def use_current_time()
    @backup_time = get_time()
    @folder = "#{@directory}backup-#{@backup_time}/"
  end

  def get_backup_file_name()
    return get_file_name_using_id("backup")
  end

  def get_log_file_name()
    return get_file_name_using_id("log")
  end

  def make_backup()
    build_backup_directory()
    system("pg_dump #{@database} > #{get_backup_file_name()}.sql")
    log_database("#{get_log_file_name()}.txt")
  end

  def make_zipped_backup()
    build_backup_directory()
    system("pg_dump #{@database} | gzip > #{get_backup_file_name()}.gz")
    log_database("#{get_log_file_name()}.txt")
  end

  private

  def get_file_name_using_id(id)
    return "#{@folder}#{id}-#{@backup_time}"
  end

  def get_time()
    return Time.now.strftime("%d-%m-%Y__%Hh%Mm%Ss")
  end

  def build_backup_directory()
    prepare_folder(@directory)
    prepare_folder(@folder)
  end

  def prepare_folder(location)
    if(!File.directory?(location))
      FileUtils.mkdir(location)
    end
  end

end
