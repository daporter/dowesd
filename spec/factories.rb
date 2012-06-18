FactoryGirl.define do
  factory :user do
    name     'David Porter'
    email    'david@example.com'
    password              'foobar'
    password_confirmation 'foobar'
  end
end
