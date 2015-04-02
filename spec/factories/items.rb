FactoryGirl.define do

  factory :item do |f|
    f.title { Faker::Lorem.word }
  end

  factory :invalid_item, parent: :item do |f|
    f.title nil
  end

end
