class CreateDnsZoneARecords < ActiveRecord::Migration
  def change
    create_table :dns_zone_a_records do |t|
      t.string :name
      t.string :address, :null => true
      t.references :dns_zone, index: true
      t.references :user,:null => false
      t.timestamp :lastset

      t.timestamps
    end

    add_index :dns_zone_a_records, [:name, :dns_zone_id], :name => :arecord_idx, :unique => true
  end
end
