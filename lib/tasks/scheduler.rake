desc "This task is called by the Heroku scheduler add-on"
task :send_daily_emails => :environment do
  puts "Sending daily emails..."
  User.send_daily_emails
  puts "Done."
end
