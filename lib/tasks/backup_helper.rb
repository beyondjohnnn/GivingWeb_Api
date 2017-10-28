require 'fileutils'

class BackUpHelper

  def initialize(target_directory)
    @directory = target_directory

    if(!File.directory?(@directory))
      FileUtils.mkdir(@directory)
    end
  end

  def getBackupPath()
    time = Time.now.strftime("%d-%m-%Y__%Hh%Mm%Ss")
    return "#{@directory}backup-#{time}"
  end

end
