class CreateBooks < ActiveRecord::Migration
  def up
    create_table :books do |t|
      t.integer :author_id, :null => false
      t.string :title

      t.timestamps
    end
    add_foreign_key :books, :authors, :column => :author_id, :name => 'books_author_fk'
    add_index       :books, [:author_id, :title], :unique => true, :name => 'books_author_title_uidx'
  end

  def down
    drop_table :books
  end
end
