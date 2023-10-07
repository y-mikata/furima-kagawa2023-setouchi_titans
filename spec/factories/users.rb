FactoryBot.define do
  factory :user do
    nickname                  { '橋本' }
    email                     {Faker::Internet.email }
    password                  { 'test1234' }
    password_confirmation     { password }
    first_name                { '橋本' }
    last_name                 { '光' }
    first_name_kana           { 'ハシモト' }
    last_name_kana            { 'ヒカル' }
    birthday                  { '1991/11/05' }
  end
end
