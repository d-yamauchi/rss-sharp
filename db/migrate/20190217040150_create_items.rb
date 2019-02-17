class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.references :site, foreign_key: true, :null => false
      t.string :title, :null => false
      t.string :url, :null => false
      t.boolean :unread, :null => false, default: 1

      t.timestamps
    end
  end
end
