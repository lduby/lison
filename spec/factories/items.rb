FactoryGirl.define do

  factory :item do |f|
    f.title { Faker::Lorem.sentence(2, true, 3) }
  end

  factory :invalid_item, parent: :item do |f|
    f.title nil
  end

end
