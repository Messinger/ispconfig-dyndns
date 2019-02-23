import Home from '../components/Home'
import DnsHostRecords from '../components/dns_host_records/dns_host_records'
import DnsHostRecord from '../components/dns_host_records/dns_host_record'
import Users from '../components/admin/users'
import User from '../components/admin/user'
import SignUp from '../components/users/sign_up'
import IspDnsZones from '../components/client/isp_dns_zones'
import IspDnsZone from '../components/client/isp_dns_zone'
import AccountsLogin from '../components/shared/accounts_login'
import FinishSignup from '../components/users/finish_signup'
import SendConfirmation from '../components/users/send_confirmation'

export routes = [
  { path: '', component: Home, name: 'home' },
  { path: '/dns-host-records/:id', component: DnsHostRecord, props: true, name: 'dns_host_record' },
  { path: '/dns-host-records',component: DnsHostRecords, name: 'dns_host_records'}
  { path: '/users/signup', component: SignUp, name: 'user_signup' }
  { path: '/admin/users/:id', component: User, props: true, name: 'admin_userdetail' }
  { path: '/admin/users', component: Users, name: 'admin_userlist'}
  { path: '/client/isp_dns_zone/:id', component: IspDnsZone, name: 'IspDnsZone', props: true }
  { path: '/client/isp_dns_zones', component: IspDnsZones, name: 'IspDnsZones' }
  { path: '/:usertype/login', component: AccountsLogin, props: true, name: 'userlogin' }
  { path: '/:usertype/sign_in', component: AccountsLogin, props: true, name: 'usersignin' }
  { path: '/profile/:id/finish_signup', component: FinishSignup, props: true, name: 'finishsignup' }
  { path: '/user/send_confirmation', component: SendConfirmation, name: 'send_confirmation' }
]
