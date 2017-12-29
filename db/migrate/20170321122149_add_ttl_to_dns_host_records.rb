class AddTtlToDnsHostRecords < ActiveRecord::Migration
  def change
    add_column :dns_host_records, :ttl, :integer, :default => 300, :null => false
  end
end
