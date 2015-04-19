FactoryGirl.define do

  factory :author do |f|
    f.firstname { Faker::Name.first_name }
    f.lastname { Faker::Name.last_name }
    f.about { Faker::Lorem.paragraph }
  end

  factory :invalid_author, parent: :author do |f|
    f.firstname nil
  end


end
