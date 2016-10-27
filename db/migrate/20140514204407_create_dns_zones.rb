class CreateDnsZones < ActiveRecord::Migration

  def up
    create_table :dns_zones do |t|
      t.string :name, :null => false
      t.string :isp_dnszone_origin, :null => false
      t.integer :isp_dnszone_id, :null => false
      t.integer :isp_client_user_id, :null => false
      t.boolean :is_public, :default => false, :null => false

      t.timestamps
    end
    add_index :dns_zones, :name, unique: true
    add_index :dns_zones, :isp_dnszone_origin, unique: true
    add_index :dns_zones, :isp_dnszone_id, unique: true
    add_index :dns_zones, :isp_client_user_id
  end

  def down
    remove_index :dns_zones, :name
    remove_index :dns_zones, :isp_dnszone_origin
    remove_index :dns_zones, :isp_dnszone_id
    remove_index :dns_zones, :isp_client_user_id
    drop_table :dns_zones
  end

end

