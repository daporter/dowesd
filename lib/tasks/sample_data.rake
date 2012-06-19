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

    users = User.all
    50.times do
      date        = rand(50).days.ago
      description = Faker::Lorem.sentence(1)
      amount      = rand(10000)
      users.each do |user|
        user.txns.create! date: date, description: description, amount: amount
      end
    end
  end
end
