import Home from '../components/Home'
import DnsHostRecords from '../components/dns_host_records/dns_host_records'
import DnsHostRecord from '../components/dns_host_records/dns_host_record'
import Users from '../components/users/users'

export routes = [
  { path: '', component: Home },
  { path: '/dns-host-records/:id', component: DnsHostRecord, props: true },
  { path: '/dns-host-records',component: DnsHostRecords},
  { path: '/users', component: Users},
]
