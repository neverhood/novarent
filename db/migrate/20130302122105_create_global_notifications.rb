class CreateGlobalNotifications < ActiveRecord::Migration
  def change
    create_table :global_notifications do |t|
      t.string :text
      t.string :english_text

      t.boolean :active, default: false
      t.timestamps
    end
  end
end
