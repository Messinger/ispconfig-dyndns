<template>
  <div id="app">
    <p>{{ message }}</p>
    <csrf></csrf>
  </div>
</template>

<script>
  import CSRF from 'components/shared/csrf.vue';
  export default {
    components: {
      csrf: CSRF
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
