FactoryGirl.define do
  factory :collection do |f|
    f.name { Faker::Lorem.word }
    f.about { Faker::Lorem.paragraph }
  end

  factory :invalid_collection, parent: :collection do |f|
    f.name nil
  end

end
