class CreateRentRequests < ActiveRecord::Migration
  def change
    create_table :rent_requests do |t|
      t.string :receipt_location, null: false, default: ''
      t.string :drop_off_location
      t.datetime :receipt_at
      t.datetime :drop_off_at
      t.string :name, null: false, default: ''
      t.string :email, null: false, default: ''
      t.string :phone
      t.boolean :confirm_drop_off_location, default: false
      t.boolean :drop_off_at_receipt, default: false
      t.boolean :has_child_seat
      t.boolean :has_gps
      t.boolean :has_additional_driver
      t.integer :car_id
      t.text :message
      t.integer :request_type, null: false
      t.integer :special_time_period
      t.integer :driving_service
      t.integer :number_of_babe_seats, default: 0
      t.integer :number_of_child_seats, default: 0
    end
  end
end
