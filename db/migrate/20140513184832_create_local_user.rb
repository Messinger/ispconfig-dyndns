class CreateLocalUser < ActiveRecord::Migration
  def up
    create_table :local_users do |t|
      t.string :last_name, :null => false
      t.string :first_name, :null => false
      t.string :login_id, :null => false
      t.string :email, :null => false
      t.timestamps
    end
    add_index :local_users, :login_id, :unique => true
    add_index :local_users, :email, :unique => true
  end
  
  def down
    remove_index :local_users, :login_id
    remove_index :local_users, :email
    drop_table :local_users
  end

end
