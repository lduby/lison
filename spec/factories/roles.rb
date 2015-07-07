FactoryGirl.define do
  factory :role do |f|
    f.name { Faker::Lorem.word }
    f.description { Faker::Lorem.paragraph }
  end

  factory :invalid_role, parent: :role do |f|
    f.name nil
  end

end
