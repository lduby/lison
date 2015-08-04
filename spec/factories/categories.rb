FactoryGirl.define do
  factory :category do |f|
    f.name { Faker::Lorem.word }
    f.about { Faker::Lorem.paragraph(2, false, 0) }
  end

  factory :invalid_category, parent: :category do |f|
    f.name nil
  end

  factory :invalid_about_category, parent: :category do |f|
    f.about { Faker::Lorem.paragraph(70, true, 30) }
  end

end
