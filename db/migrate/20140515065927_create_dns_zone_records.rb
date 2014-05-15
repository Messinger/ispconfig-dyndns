class CreateDnsZoneRecords < ActiveRecord::Migration
  def change
    create_table :dns_zone_records do |t|
      t.string :name,:index => true, :null => false
      t.references :dns_zone, :index => true
      t.references :user, :index => true
      t.timestamps
    end

    add_index :dns_zone_records, [:name,:dns_zone_id], :name => :recordname_idx, :unique => true

  end
end
