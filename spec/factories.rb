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
    date                   Date.today
    sequence(:description) { |n| "Transaction #{n}" }
    sequence(:amount)      { |n| n }
    user
    account
  end
end
