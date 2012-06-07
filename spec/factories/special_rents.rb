# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :special_rent do
    car_id 1
    friday_to_monday 1
    thursday_to_monday 1
    friday_to_tuesday 1
  end
end
