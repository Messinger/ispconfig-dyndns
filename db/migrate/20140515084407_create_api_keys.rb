class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :access_token, null: false
      t.references :token_parent, polymorphic: true, null: false
      #index: true, unique: true, null: false

      t.timestamps
    end

    add_index :api_keys, [:token_parent_id,:token_parent_type], name: :tokenparent_idx, unique: true
    add_index :api_keys, :access_token, unique: true
  end
end