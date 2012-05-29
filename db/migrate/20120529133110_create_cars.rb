class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.string :name, null: false, default: ''
      t.string :manufacturer, null: false, default: ''
      t.float :engine
      t.integer :number_of_passengers, default: 4
      t.integer :number_of_doors, default: 4
      t.integer :transmission
      t.boolean :conditioner, default: false
      t.boolean :leather, default: false
      t.integer :minimum_reserve, default: 1
      t.string :photo
    end
  end
end
