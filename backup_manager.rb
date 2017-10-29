
require 'fileutils'
require_relative './lib/sql_runner'
require_relative './lib/backup_helper'
require_relative './lib/database_logger'

class BackUpManager
  DIVIDER = "--------------------------------------------------"
  def initialize(database_name, backup_dir)
    @database_name = database_name
    @backup_dir = backup_dir
  end

  def run()
    run = true
    while(run)
      puts DIVIDER
      puts "Welcome to the backup managaer."
      puts "What would you like to do"

      input = get_user_input(["1", "2", "3"]) do
        puts "1) Make backup of current state\n" +
        "2) Restore a backup\n"+
        "3) Exit"
      end

      case input
        when "1"
          make_backup()
        when "2"
          run_restore_backup_menu()
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
    return input
  end

  def is_input_valid?(input, options)
    result = options.include?(input)
    if(!result)
      to_output = options.join(", ")
      puts "Error please enter: #{to_output}"
    end
    return result
  end

  def run_restore_backup_menu()
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
    selected_file = files[(input.to_i)-1]

    if(input != input_options[-1])
      question = "Restoring #{selected_file} will override the current" +
      "database with this (a backup of the current state will also be made)"
      if(confirm_input(question))
        make_backup()
        delete_all_data()
        restore_zipped_backup(selected_file)
      end
    end
  end

  def confirm_input(question)
    puts question
    puts "Are you sure?"
    input = get_user_input(["1", "2"]) do
      puts "1) yes\n2) no"
    end
    return input == "1"
  end

  def delete_all_data()
    tables = SqlRunner.run("SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname = 'public';")
    table_data = tables.map do |table|
      command = "DROP TABLE #{table["tablename"]};"
      puts command
      count = SqlRunner.run(command)
    end
  end

  def make_backup()
    puts "starting backup"
    backup_helper = BackUpHelper.new(@database_name, @backup_dir)
    backup_helper.make_zipped_backup()
    puts "backup made"
  end

  def restore_backup(folder)
    system("psql #{@database_name} < #{@backup_dir}#{folder}/#{folder}.sql")
  end

  def restore_zipped_backup(folder)
    system("gunzip -c #{@backup_dir}#{folder}/#{folder}.gz | psql #{@database_name}")
  end

  def get_backup_file_list()
    files = Dir["#{@backup_dir}*"].map do |file|
      file.split("/")[-1]
    end
    return files.reverse()
  end
end


directory = "#{File.expand_path(File.dirname(__FILE__))}/db/backup/"
BackUpManager.new("givingweb_api_development", directory).run()
