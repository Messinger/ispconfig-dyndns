<template>
  <div id="home-container">
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
      else if this.$root.$current_user().type == 'Admin'
        this.$router.push({name:'admin_userlist'})
      else if this.$root.$current_user().type == 'Client'
        this.$router.push({name:'DnsZones'})
      else
        this.$router.push({name:'dns_host_records'})
  }
</script>

<style scoped>

</style>