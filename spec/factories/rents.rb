# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rent do
    car_id 1
    one_to_two 1
    three_to_five 1
    six_to_twelve 1
    thirteen_to_twenty_four 1
    month 1
    bail 1
  end
end
