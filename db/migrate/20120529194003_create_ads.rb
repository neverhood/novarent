class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :photo
      t.string :body
    end
  end
end
