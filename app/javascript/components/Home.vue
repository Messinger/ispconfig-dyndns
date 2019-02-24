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
      else if !!this.$root.$current_user().email_must_verified
        if !this.$root.$current_user().unconfirmed_set
          _id = this.$root.$current_user().id
          this.$router.push({name: 'finishsignup', params: {id: _id }})
        else
          this.$router.push({name: 'confirm_email'})
  }
</script>

<style scoped>

</style>