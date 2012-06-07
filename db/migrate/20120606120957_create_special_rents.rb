class CreateSpecialRents < ActiveRecord::Migration
  def change
    create_table :special_rents do |t|
      t.integer :car_id
      t.integer :friday_to_monday
      t.integer :thursday_to_monday
      t.integer :friday_to_tuesday

      t.timestamps
    end
  end
end
