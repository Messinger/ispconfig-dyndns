class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :access_token, null: false
      t.references :dns_host_record, null: false
      t.timestamps
    end

    add_index :api_keys, [:dns_host_record_id], name: :tokenparent_idx, unique: true
    add_index :api_keys, :access_token, unique: true
  end
end
