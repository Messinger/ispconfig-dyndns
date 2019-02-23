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
import AccountSecurity from '../components/users/account_security'

export routes = [
  { path: '', component: Home, name: 'home' },
  { path: '/dns-host-records/:id', component: DnsHostRecord, props: true, name: 'dns_host_record' },
  { path: '/dns-host-records',component: DnsHostRecords, name: 'dns_host_records'}
  { path: '/admin/users/:id', component: User, props: true, name: 'admin_userdetail' }
  { path: '/admin/users', component: Users, name: 'admin_userlist'}
  { path: '/client/isp_dns_zone/:id', component: IspDnsZone, name: 'IspDnsZone', props: true }
  { path: '/client/isp_dns_zones', component: IspDnsZones, name: 'IspDnsZones' }
  { path: '/:usertype/login', component: AccountsLogin, props: true, name: 'userlogin' }
  { path: '/:usertype/sign_in', component: AccountsLogin, props: true, name: 'usersignin' }
  { path: '/profile/:id/finish_signup', component: FinishSignup, props: true, name: 'finishsignup' }
  { path: '/user/signup', component: SignUp, name: 'user_signup' }
  { path: '/user/request_email_confirmation', component: AccountSecurity, name: 'send_confirmation', props: {action: 'send_confirmation',usertype: 'user' } }
  { path: '/user/request_new_password', component: AccountSecurity, name: 'request_password', props: {action: 'send_request_password',usertype: 'user' } }
  { path: '/user/request_unlock', component: AccountSecurity, name: 'request_unlock', props: {action: 'send_request_unlock',usertype: 'user' } }
  { path: '/admin/request_new_password', component: AccountSecurity, name: 'admin_request_password', props: {action: 'send_request_password',usertype: 'admin' } }
  { path: '/admin/request_unlock', component: AccountSecurity, name: 'admin_request_unlock', props: {action: 'send_request_unlock',usertype: 'admin' } }
]
