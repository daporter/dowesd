FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password              'foobar'
    password_confirmation 'foobar'
  end

  factory :txn do
    date        Date.today
    description 'Lorem ipsum'
    amount      100
    user
  end
end
