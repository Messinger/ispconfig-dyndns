class CreateDnsZoneARecords < ActiveRecord::Migration
  def change
    create_table :dns_zone_a_records do |t|
      t.string :address, :null => true
      t.references :dns_zone_record, index: true, null: false
      t.integer :isp_dns_a_record_id, index: true
      t.timestamp :lastset

      t.timestamps
    end
  end
end
