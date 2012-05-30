class CreateDrivingServices < ActiveRecord::Migration
  def change
    create_table :driving_services do |t|
      t.integer :cost
      t.integer :one_hour
      t.integer :transfer
      t.integer :mileage
      t.integer :car_id
    end
  end
end
