require './lib/db'

desc "This task is called by the Heroku cron add-on"
task :cron do
  puts "Finding most recent release"
  Version.get_versions
  puts "done."
end
