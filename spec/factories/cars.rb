# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :car do
    name 'Accord'
    manufacturer 'Honda'
    engine 1.5
    number_of_passengers 5
    number_of_doors 4
    transmission 1
    conditioner false
    minimum_reserve 1
  end
end
