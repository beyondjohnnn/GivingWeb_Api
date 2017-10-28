
require_relative './sql_runner'
require 'fileutils'

def log_database(log_file_location)

  tables = SqlRunner.run("SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname = 'public' AND tablename != 'ar_internal_metadata';")

  total_rows = 0
  table_data = tables.map do |table|
    name = table["tablename"]
    count = SqlRunner.run("SELECT COUNT(*) FROM #{name}")[0]["count"].to_i

    rows = count != 1 ? "rows" : "row"
    total_rows += count

    "#{name}: #{count} #{rows}"
  end

  overview = "Total tables: #{tables.count()}\nTotal Rows: #{total_rows}"
  File.open(log_file_location, 'w') do |file|
    file.write(overview + "\n\n" + table_data.join("\n"))
  end
end
