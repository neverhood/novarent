class RenameSpecialRentPeriod < ActiveRecord::Migration
  def up
    rename_column :special_rents, :friday_to_tuesday, :thursday_to_tuesday
  end

  def down
    rename_column :special_rents, :thursday_to_tuesday, :friday_to_tuesday
  end
end
