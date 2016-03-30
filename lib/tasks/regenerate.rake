namespace :gsoh do
  desc 'Regenerate matches for every user'
  task :regenerate_matches => :environment do
    User.all.each(&:regenerate_matches!)
  end
end
