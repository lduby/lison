FactoryGirl.define do

  factory :author do |f|
    f.firstname { Faker::Name.first_name }
    f.lastname { Faker::Name.last_name }
    f.about { Faker::Lorem.paragraph(2, false, 0) }
  end

  factory :invalid_author, parent: :author do |f|
    f.firstname nil
  end

  factory :invalid_about_author, parent: :author do |f|
    f.about { Faker::Lorem.paragraph(70, true, 30) }
  end


end
