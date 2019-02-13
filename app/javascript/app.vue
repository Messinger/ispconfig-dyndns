<template>
  <div id="app">
      <div>
        <p>{{ message }}</p>
        <csrf></csrf>
        <app-navigation></app-navigation>
        <router-view></router-view>
      </div>
  </div>
</template>

<script>
  import CSRF from 'components/shared/csrf.vue'
  import Navigation from 'components/Navigation.vue'

  export default {
    components: {
        csrf: CSRF,
        appNavigation: Navigation
    },
    data: function () {
      return {
        message: "Hello Vue!"
      }
    }
  }
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
