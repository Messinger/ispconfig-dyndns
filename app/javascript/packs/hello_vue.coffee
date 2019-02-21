# eslint no-console: 0

import Vue from 'vue/dist/vue.esm'
import VueResource from 'vue-resource'
import VueRouter from 'vue-router'
import App from '../app.vue'
import Vuetify from "vuetify"
import { routes } from './routes'
import axios from 'axios'
import 'vuetify/dist/vuetify.css'
import 'material-design-icons-iconfont/dist/material-design-icons.css'
import '@fortawesome/fontawesome-free/css/all.css'
import '@mdi/font/css/materialdesignicons.css'
import VueCookies from 'vue-cookies'
Vue.use(VueCookies)

Vue.use(VueResource)
Vue.use(VueRouter)
Vue.use(Vuetify,{
  iconfont: 'mdi'
})

console.log "Root path = #{Constants.root_path}"

window.axios = axios.create({
  baseURL: Constants.root_path,
  headers: {
    'Accept': 'application/json'
    'X-API-ONLY': '1'
  },
  xsrfCookieName: "CSRF-TOKEN",
  xsrfHeaderName: "X-CSRF-Token",
  withCredentials: false
})

import vue_axios from './vue_axios'

Vue.use(vue_axios,window.axios)

router = new VueRouter({
  routes
})

window.axios.interceptors.response.use(null,(error) ->
  if error.response.status == 401
    console.warn "Error status:",error.response
    console.log "Cookies: ",window.$cookies.keys()
    window.$cookies.remove('_dyndns_session',null, null)
    window.$cookies.remove('_session_id',null,null)
    window.Constants.current_user = null
    window.vueapp.$root.$login_changed()
    Promise.resolve(error.response)
  else
    Promise.reject(error.response)
)

document.addEventListener('DOMContentLoaded', () ->
  app = new Vue({
    el: '#mainapp',
    router,
    components: {App}
  })
  window.vueapp = app
)