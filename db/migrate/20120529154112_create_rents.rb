class CreateRents < ActiveRecord::Migration
  def change
    create_table :rents do |t|
      t.integer :car_id
      t.integer :day
      t.integer :one_to_two
      t.integer :three_to_five
      t.integer :six_to_twelve
      t.integer :thirteen_to_twenty_four
      t.integer :month
      t.integer :bail
    end
  end
end
