FactoryGirl.define do
  factory :collection do |f|
    f.name { Faker::Lorem.word }
    f.about { Faker::Lorem.paragraph(2, false, 0) }
  end

  factory :invalid_collection, parent: :collection do |f|
    f.name nil
  end

  factory :invalid_about_collection, parent: :collection do |f|
    f.about { Faker::Lorem.paragraph(70, true, 30) }
  end

end
