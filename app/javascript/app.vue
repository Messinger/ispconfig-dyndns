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
  import { user_logout } from 'packs/user_logout'


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
        this.$root.$emit('login-changed', {})
        this.$router.push('/')
    }

    mounted: () ->
      this.$root.$confirm = this.$refs.confirm.open
      this.$root.$spinner = this.$refs.spinner
      this.$root.$login_changed = this.login_changed
      this.$root.$errors_to_array = (errors) ->
        errors_to_array.error_hash_to_array(errors)
      this.$root.$logout = user_logout.user_logout
  }
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
