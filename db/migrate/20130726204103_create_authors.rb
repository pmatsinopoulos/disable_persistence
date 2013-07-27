class CreateAuthors < ActiveRecord::Migration
  def up
    create_table :authors do |t|
      t.string :first_name, :null => false
      t.string :last_name,  :null => false

      t.timestamps
    end
    add_index :authors, [:first_name, :last_name], :unique => true, :name => 'authors_first_name_last_name_uidx'
  end

  def down
    remove_index :authors, :name => 'authors_first_name_last_name_uidx'
    drop_table :authors
  end
end
