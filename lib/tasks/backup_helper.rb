require 'fileutils'

class BackUpHelper

  def initialize(target_directory)
    @directory = target_directory
    @backup_time = get_time()
    @folder = "#{@directory}backup-#{@backup_time}/"
    build_backup_directory()
  end

  def get_backup_file_name()
    return get_file_name_using_id("backup")
  end

  def get_log_file_name()
    return get_file_name_using_id("log")
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
