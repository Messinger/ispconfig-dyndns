<template>

  <div id="app">
    <v-app id="dyndns">
      <confirm ref="confirm"></confirm>
      <spinner ref="spinner"></spinner>
      <app-navigation></app-navigation>
      <router-view></router-view>
    </v-app>
  </div>
</template>

<script lang="coffee">
  import 'regenerator-runtime/runtime'
  import Navigation from 'components/Navigation.vue'
  import confirm from 'components/shared/confirm'
  import spinneroverlay from 'components/shared/spinneroverlay'
  import { errors_to_array } from 'packs/errors_to_array.coffee'
  import { user_service } from 'packs/user_service'


  export default {
    components: {
      appNavigation: Navigation
      confirm: confirm
      spinner: spinneroverlay

    }
    data: () ->
      {
        message: "Töf"
      }

    methods: {
      login_changed: () ->
        this.$root.$update_user()
        this.$root.$emit('login-changed', {})
        if !!window.Constants.current_user
          this.$router.push('/')
        else
          this.$router.push({name: 'userlogin',params:{usertype: 'user'}})
    }

    beforeMount: () ->
      console.log "Mount me"
      this.$root.$login_changed = this.login_changed
      this.$root.$errors_to_array = (errors) ->
        errors_to_array.error_hash_to_array(errors)
      this.$root.$logout = user_service.user_logout
      this.$root.$retrieve_current_user = user_service.retrieve_current_user
      this.$root.$update_user = user_service.update_current_user
      this.$root.$current_user = user_service.current_user

    mounted: () ->
      this.$root.$confirm = this.$refs.confirm.open
      this.$root.$spinner = this.$refs.spinner
  }
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
