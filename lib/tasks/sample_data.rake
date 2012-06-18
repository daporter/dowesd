namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    User.create!(name:  'User 1',
                 email: 'user1@example.org',
                 password:              'foobar',
                 password_confirmation: 'foobar')
    User.create!(name:  'User 2',
                 email: 'user2@example.org',
                 password:              'bazbat',
                 password_confirmation: 'bazbat')
  end
end
