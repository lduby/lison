FactoryGirl.define do

  factory :user do
    email { Faker::Internet.email }
    password 's3cur3p@ssw0rd'
    password_confirmation 's3cur3p@ssw0rd'
    confirmed_at Time.now

    trait :donald do
      # name 'donald'
      email 'donald@example.com'
      roles Role.where(name: "Team")
    end
  end

  factory :invalid_user, parent: :user do |f|
    f.email nil
  end


end
