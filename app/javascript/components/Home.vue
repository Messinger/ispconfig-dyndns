<template>
  <div id="home-container">
    <h2>My Home is my Castle!</h2>
  </div>
</template>

<script lang="coffee">
  export default {
    name: "home"
    mounted: () ->
      if !window.Constants.current_user
        this.$router.push({name: 'userlogin', params: {usertype: 'user'}})
  }
</script>

<style scoped>

</style>