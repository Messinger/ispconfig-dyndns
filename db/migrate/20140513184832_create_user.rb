class CreateUser < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :last_name, :null => false
      t.string :first_name, :null => false
      t.string :login_id, :null => false
      t.string :email, :null => false
      t.string :password, :null => false
      t.boolean :active
      t.timestamps
    end
    add_index :users, :login_id, :unique => true
    add_index :users, :email, :unique => true
  end
  
  def down
    remove_index :users, :login_id
    remove_index :users, :email
    drop_table :users
  end

end
