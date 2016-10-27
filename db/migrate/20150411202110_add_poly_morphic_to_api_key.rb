class AddPolyMorphicToApiKey < ActiveRecord::Migration
  def up
    remove_index :api_keys, name: :tokenparent_idx
    rename_column :api_keys, :dns_host_record_id, :dns_entry_id
    add_column :api_keys, :dns_entry_type, :string, {:default => 'DnsHostRecord', :null => false}
    add_index :api_keys, [:dns_entry_id,:dns_entry_type], name: :tokenparent_idx, unique: true
  end

  def down
    remove_index :api_keys, name: :tokenparent_idx
    rename_column :api_keys, :dns_entry_id, :dns_host_record_id
    remove_column :api_keys, :dns_entry_type
    add_index :api_keys, [:dns_host_record_id], name: :tokenparent_idx, unique: true
  end

end
