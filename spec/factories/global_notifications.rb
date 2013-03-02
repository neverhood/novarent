# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :global_notification do
    text "MyString"
    active false
  end
end
