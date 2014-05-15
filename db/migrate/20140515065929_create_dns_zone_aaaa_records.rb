class CreateDnsZoneAaaaRecords < ActiveRecord::Migration
  def change
    create_table :dns_zone_aaaa_records do |t|
      t.string :address, :null => true
      t.references :dns_zone_record, index: true, :null => false
      t.integer :isp_dns_aaaa_record_id, index: true
      t.timestamp :lastset
      t.timestamps
    end
  end
end
