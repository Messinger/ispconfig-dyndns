class AddSessionsTable < ActiveRecord::Migration
  def up
    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end
    add_index :sessions, :session_id, :name => 's_id_idx'
    add_index :sessions, :updated_at, :name => 's_update_idx'
  end

  def down
    remove_index :sessions, :name => 's_id_idx'
    remove_index :sessions, :name => 's_update_idx'
    drop_table :sessions    
  end
end
