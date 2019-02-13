# eslint no-console: 0

  import Vue from 'vue/dist/vue.esm'
  import VueResource from 'vue-resource'
  import App from '../app.vue'

  Vue.use(VueResource)

  document.addEventListener('DOMContentLoaded', () ->
     app = new Vue({
       el: '#hello'
       data: {
         message: "Can you say hello???"
       }
       components: {App}
     })
  )
