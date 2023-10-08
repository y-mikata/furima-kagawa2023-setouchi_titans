FactoryBot.define do
  factory :item do
    name             { Faker::Lorem.sentence[0..40] }
    info             { Faker::Lorem.sentence[0..1_000] }
    category_id      { Faker::Number.between(from: 2, to: 11) }
    condition_id     { Faker::Number.between(from: 2, to: 7) }
    price            { Faker::Number.between(from: 300, to: 9_999_999) }
    postage_type_id  { Faker::Number.between(from: 2, to: 3) }
    prefecture_id    { Faker::Number.between(from: 2, to: 48) }
    shipping_time_id { Faker::Number.between(from: 2, to: 4) }
    association :user

    after(:build) do |item|
      item.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end
