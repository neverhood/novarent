class CreateRentRequests < ActiveRecord::Migration
  def change
    create_table :rent_requests do |t|
      t.string :receipt_location, null: false, default: ''
      t.string :drop_off_location, null: false, default: ''
      t.datetime :receipt_at
      t.datetime :drop_off_at
      t.string :name, null: false, default: ''
      t.string :email, null: false, default: ''
      t.string :phone
      t.boolean :confirm_drop_off_location, default: false
      t.boolean :drop_off_at_receipt, default: false
      t.integer :car_id
      t.text :message
      t.boolean :confirmed, default: false
    end
  end
end
