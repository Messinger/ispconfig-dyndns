<template>
  <v-app id="dyndns-app">
    <toastqueue ref="toast"></toastqueue>
    <confirm ref="confirm"></confirm>
    <spinner ref="spinner"></spinner>
    <app-navigation></app-navigation>
    <v-content>
      <router-view></router-view>
    </v-content>
  </v-app>
</template>

<script lang="coffee">
  import 'regenerator-runtime/runtime'
  import Navigation from 'components/Navigation.vue'
  import confirm from 'components/shared/confirm'
  import spinneroverlay from 'components/shared/spinneroverlay'
  import toastqueue from 'components/shared/toast_queue'
  import { errors_to_array } from 'packs/errors_to_array.coffee'
  import { user_service } from 'packs/user_service'

  export default {
    components: {
      appNavigation: Navigation
      confirm: confirm
      spinner: spinneroverlay
      toastqueue: toastqueue

    }
    data: () ->
      {}

    methods: {
      login_changed: () ->
        console.log "Retrieved login changed"
        result = await this.$root.$update_user()

        console.log "Set user to value"
        if !!window.Constants.current_user
          this.$router.push('/')
        else
          this.$router.push({name: 'userlogin',params:{usertype: 'user'}})

        console.log "Emit signal"
        this.$root.$emit('login-changed', {})


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
      this.$root.$toast = this.$refs.toast

      for flash in window.flash_errors
        usecolor = switch(flash[0])
          when 'notice' then "success"
          else flash[0]
        this.$refs.toast.addNotification({text: flash[1], color: usecolor,top: true})
  }
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
