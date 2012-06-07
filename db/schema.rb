# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120606120957) do

  create_table "ads", :force => true do |t|
    t.string "photo"
    t.string "body"
  end

  create_table "cars", :force => true do |t|
    t.string  "name",                 :default => "",    :null => false
    t.string  "manufacturer",         :default => "",    :null => false
    t.float   "engine"
    t.integer "number_of_passengers", :default => 4
    t.integer "number_of_doors",      :default => 4
    t.integer "transmission"
    t.boolean "conditioner",          :default => false
    t.boolean "leather",              :default => false
    t.integer "minimum_reserve",      :default => 1
    t.string  "photo"
  end

  create_table "driving_services", :force => true do |t|
    t.integer "cost"
    t.integer "one_hour"
    t.integer "transfer"
    t.integer "mileage"
    t.integer "car_id"
  end

  create_table "rent_requests", :force => true do |t|
    t.string   "receipt_location",          :default => "",    :null => false
    t.string   "drop_off_location"
    t.datetime "receipt_at"
    t.datetime "drop_off_at",                                  :null => false
    t.string   "name",                      :default => "",    :null => false
    t.string   "email",                     :default => "",    :null => false
    t.string   "phone"
    t.boolean  "confirm_drop_off_location", :default => false
    t.boolean  "drop_off_at_receipt",       :default => false
    t.boolean  "has_child_seat"
    t.boolean  "has_gps"
    t.boolean  "has_additional_driver"
    t.integer  "car_id"
    t.text     "message"
    t.integer  "total"
    t.boolean  "confirmed",                 :default => false
    t.integer  "request_type",                                 :null => false
    t.string   "special_time_period"
  end

  create_table "rents", :force => true do |t|
    t.integer "car_id"
    t.integer "day"
    t.integer "one_to_two"
    t.integer "three_to_five"
    t.integer "six_to_twelve"
    t.integer "thirteen_to_twenty_four"
    t.integer "month"
    t.integer "bail"
  end

  create_table "special_rents", :force => true do |t|
    t.integer  "car_id"
    t.integer  "friday_to_monday"
    t.integer  "thursday_to_monday"
    t.integer  "friday_to_tuesday"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

end
