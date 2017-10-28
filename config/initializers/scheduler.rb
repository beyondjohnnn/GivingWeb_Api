# https://richonrails.com/articles/background-tasks-with-rufus-scheduler
require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

scheduler.every '5s' do
  system("rake db:dump_zip")
end
