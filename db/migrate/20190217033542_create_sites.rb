class CreateSites < ActiveRecord::Migration[5.2]
  def change
    create_table :sites do |t|
      t.string :name, :null => false
      t.string :url, :null => false, index: { unique: true }
      t.boolean :enabled, :null => false

      t.timestamps
    end
  end
end
