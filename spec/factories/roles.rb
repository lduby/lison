FactoryGirl.define do
  factory :role do |f|
    f.name { Faker::Lorem.word }
    f.description { Faker::Lorem.paragraph(2, false, 0) }
  end

  factory :invalid_role, parent: :role do |f|
    f.name nil
  end

  factory :invalid_about_role, parent: :role do |f|
    f.description { Faker::Lorem.paragraph(70, true, 30) }
  end

end
