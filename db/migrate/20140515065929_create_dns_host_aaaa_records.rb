class CreateDnsHostAaaaRecords < ActiveRecord::Migration
  def change
    create_table :dns_host_aaaa_records do |t|
      t.string :address, :null => true
      t.references :dns_host_record, index: true, :null => false
      t.integer :isp_dns_aaaa_record_id
      t.timestamp :lastset
      t.timestamps
    end

    add_index :dns_host_aaaa_records, :isp_dns_aaaa_record_id, :unique => true
  end
end
