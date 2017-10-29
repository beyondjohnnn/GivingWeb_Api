require 'fileutils'

class BackUpManager
  DIVIDER = "--------------------------------------------------"
  def initialize(backup_dir)
    @backup_dir = backup_dir
  end

  def run()
    ## set the time interval between new backups
    # restore a selected database
    # set the max space to use up / max number of backups to make
    run = true
    while(run)
      puts DIVIDER
      puts_manager_intro()

      input = nil
      valid_input = false
      while(!valid_input)
        puts "1) Restore a backup\n"+
          "2) Change how many backup to store before deleting old ones\n" +
          "3) Exit"
        input = gets.chomp
        valid_input = is_input_valid?(input, ["1", "2", "3"])
        puts DIVIDER
      end

      case input
        when "1"
          run_restore_backup()
        when "2"
          run_change_storage()
        when "3"
          run = false
      end
    end
    puts "Exit"
  end

  private

  def get_user_input(options, &call_back)
    input = nil
    valid_input = false
    while(!valid_input)
      call_back.call()
      input = gets.chomp
      valid_input = is_input_valid?(input, options)
      puts DIVIDER
    end
  end

  def puts_manager_intro()
    puts "Welcome to the backup managaer."
    puts "What would you like to do"
  end

  def run_restore_backup()
    files = get_backup_file_list()

    input_options = []
    for index in (0..files.count())
      input_options.push((index+1).to_s)
    end

    input = get_user_input(input_options) do
      puts "Please select which file you would like to use to restore the database"
      files.each_with_index do |file, index|
        puts "#{(index+1).to_s}) #{file}"
      end
      puts "#{input_options[-1]}) Back"
    end
  end

  def run_change_storage()
    puts "run_change_storage"
  end

  def is_input_valid?(input, options)
    result = options.include?(input)
    if(!result)
      to_output = options.join(", ")
      puts "Error please enter: #{to_output}"
    end
    return result
  end

  def get_backup_file_list()
    return Dir["#{@backup_dir}*"].map do |file|
      file.split("/")[-1]
    end
  end

end

BackUpManager.new("./db/backup/").run()
