# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rent_request do
    receipt_location "MyString"
    drop_off_location "MyString"
    receipt_at "2012-05-30 12:36:59"
    drop_off_at "2012-05-30 12:36:59"
    name "MyString"
    email "MyString"
    phone "MyString"
    confirm_drop_off_lication false
    drop_off_at_receipt false
    car_id 1
    message "MyText"
    confirmed false
  end
end
