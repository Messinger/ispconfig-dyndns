import Home from 'components/Home'
import DnsHostRecords from 'components/dns_host_records/dns_host_records'

export routes = [
  { path: '', component: Home },
  { path: '/dns-host-records',component: DnsHostRecords}
]