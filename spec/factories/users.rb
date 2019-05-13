FactoryBot.define do
  factory :user do
    email { 'joaocvalerio@gmail.com' }
    password { 123456 }
    name { 'joao' }
  end

  factory :random_user, class: User do
    name { Faker::Name.name }
    email { Faker::Internet.safe_email }
    password { 123456 }
  end
end
