namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_accounts
    make_txns
  end
end

def make_users
  100.times do |n|
    name     = Faker::Name.name
    email    = "example-#{n}@example.org"
    password = "password"
    User.create!(name:                  name,
                 email:                 email,
                 password:              password,
                 password_confirmation: password)
  end
end

def make_accounts
  users          = User.all
  user           = users[0]
  account_owners = users[1..20]
  other_parties  = users[21..40]
  other_parties.each do |other_party|
    user.open_account_with! other_party, rand(100000)
  end
  account_owners.each do |account_owner|
    account_owner.open_account_with! user, rand(100000)
  end
end

def make_txns
  users = User.all(limit: 6)
  50.times do
    date        = rand(50).days.ago
    description = Faker::Lorem.sentence(1)
    amount      = rand(10000)
    users.each do |user|
      user.txns.create!(date:        date,
                        description: description,
                        amount:      amount,
                        account_id:  user.accounts.first.id)
    end
  end
end
