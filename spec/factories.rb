FactoryGirl.define do
  factory :user, aliases: [:other_party] do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password              "password"
    password_confirmation "password"
  end

  factory :account do
    user
    other_party
  end

  factory :txn do
    date        Date.today
    description "A transaction"
    amount      1234
    user
    account
  end
end
