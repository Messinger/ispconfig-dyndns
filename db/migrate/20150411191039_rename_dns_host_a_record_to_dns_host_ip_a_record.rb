class RenameDnsHostARecordToDnsHostIpARecord < ActiveRecord::Migration
  def up
    rename_table :dns_host_a_records, :dns_host_ip_a_records
  end

  def down
    rename_table :dns_host_ip_a_records, :dns_host_a_records
  end
end
