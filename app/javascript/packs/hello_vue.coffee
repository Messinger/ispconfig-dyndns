# eslint no-console: 0

  import Vue from 'vue/dist/vue.esm'
  import VueResource from 'vue-resource'
  import VueRouter from 'vue-router';
  import App from '../app.vue'
  import Vuetify from "vuetify"
  import { routes } from './routes'

  import 'vuetify/dist/vuetify.css'
  import 'material-design-icons-iconfont/dist/material-design-icons.css'

  Vue.use(VueResource)
  Vue.use(VueRouter)
  Vue.use(Vuetify,{
    iconfont: 'md'
  })

  router = new VueRouter({
    routes
  })

  document.addEventListener('DOMContentLoaded', () ->
     app = new Vue({
       el: '#mainapp',
       router,
       components: {App}
     })
  )