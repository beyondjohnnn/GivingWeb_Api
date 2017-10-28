
require_relative './Sql_runner'

def log_database()

  tables = SqlRunner.run("SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname = 'public' AND tablename != 'ar_internal_metadata';")

  data = tables.map do |table|
    name = table["tablename"]
    count = SqlRunner.run("SELECT COUNT(*) FROM #{name}")[0]["count"]
    rows = count != "1" ? "rows" : "row"
    "#{name}: #{count} #{rows}"
  end

  puts data.join("\n")
end
