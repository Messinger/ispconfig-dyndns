<template>
  <div id="app">
    <p>{{ message }}</p>
    <csrf></csrf>
    <app-navigation></app-navigation>
    <router-view></router-view>
  </div>
</template>

<script>
    import 'regenerator-runtime/runtime';
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
