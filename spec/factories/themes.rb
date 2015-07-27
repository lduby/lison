FactoryGirl.define do
  factory :theme do |f|
    f.name { Faker::Lorem.word }
    f.about { Faker::Lorem.paragraph(2, false, 0) }
  end

  factory :invalid_theme, parent: :theme do |f|
    f.name nil
  end

  factory :invalid_about_theme, parent: :theme do |f|
    f.about { Faker::Lorem.paragraph(70, true, 30) }
  end

end
