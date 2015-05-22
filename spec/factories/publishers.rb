FactoryGirl.define do
  factory :publisher do |f|
    f.name { Faker::Lorem.word }
    f.about { Faker::Lorem.paragraph }
  end

  factory :invalid_publisher, parent: :publisher do |f|
    f.name nil
  end

end
