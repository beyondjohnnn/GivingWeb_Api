# https://richonrails.com/articles/background-tasks-with-rufus-scheduler
require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

scheduler.every '1m' do
  system("rake db:dump")
end
