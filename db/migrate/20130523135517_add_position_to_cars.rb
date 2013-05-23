class AddPositionToCars < ActiveRecord::Migration
  def change
    add_column :cars, :position, :integer
  end
end
