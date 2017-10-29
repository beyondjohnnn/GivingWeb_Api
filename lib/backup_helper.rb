require 'fileutils'

class BackUpHelper

  attr_reader :directory, :backup_time, :folder

  def initialize(database, target_directory)
    @database = database
    @directory = target_directory
    @backup_time = get_time()
    @folder = "#{@directory}backup-#{@backup_time}/"
    @max_storage = 1
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
    backup(true)
  end

  def make_zipped_backup()
    backup(false)
  end

  private

  def backup(is_zipped)
    if(is_storage_over_max())
      delete_oldest_folder()
    end
    build_backup_directory()
    if(is_zipped)
      system("pg_dump #{@database} > #{get_backup_file_name()}.sql")
    else
      system("pg_dump #{@database} | gzip > #{get_backup_file_name()}.gz")
    end
    log_database("#{get_log_file_name()}.txt")
  end

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

  def delete_oldest_folder()
    backup_folders = Dir["./db/backup/*"]
    backup_folders.sort! do |file1, file2|
      File.ctime(file1) <=> File.ctime(file2)
    end
    to_delete = backup_folders[0]
    puts "Deleting folder: #{to_delete}"
    system("rm -rf #{to_delete}")
  end

  def is_storage_over_max()
    size = calc_directory_size_in_mega_bytes()
    result = size >= @max_storage
    if(result)
      puts "Storage over #{@max_storage}: #{size}"
    end
    return result
  end

  def calc_directory_size_in_mega_bytes()
    backup_folders = Dir["#{@directory}*"]

    total = 0
    backup_folders.each do |folder|
      files = Dir["#{folder}/*"]
      files.each do |file|
        total += File.size(file)
      end
    end
    p total/1000000
    return total/1000000
  end
end
