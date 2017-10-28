require 'fileutils'

class BackUpHelper

  def initialize(target_directory)
    @directory = target_directory
  end

  def getBackupFileName()
    time = Time.now.strftime("%d-%m-%Y__%Hh%Mm%Ss")
    return "#{@directory}/backup-#{time}"
  end

end
