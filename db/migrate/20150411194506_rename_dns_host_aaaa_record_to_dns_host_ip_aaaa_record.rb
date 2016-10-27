class RenameDnsHostAaaaRecordToDnsHostIpAaaaRecord < ActiveRecord::Migration
  def up
    rename_table :dns_host_aaaa_records, :dns_host_ip_aaaa_records
  end

  def down
    rename_table :dns_host_ip_aaaa_records, :dns_host_aaaa_records
  end
end
