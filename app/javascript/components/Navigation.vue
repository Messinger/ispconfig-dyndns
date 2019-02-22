<template>
  <v-toolbar >
    <v-toolbar-side-icon></v-toolbar-side-icon>
    <v-toolbar-title>Dyndns</v-toolbar-title>
    <v-toolbar-items class="hidden-sm-and-down">
      <v-btn flat to="/">
        Home
      </v-btn>
      <v-btn flat :to="{name: 'dns_host_records'}" v-if="isUser()||isClient()">
        DNS Einträge
      </v-btn>
      <v-btn flat :to="{name: 'IspDnsZones'}" v-if="isClient()">
        ISP Config DNS
      </v-btn>
      <v-btn flat :to="{name: 'admin_userlist'}" v-if="isAdmin()">
        Userlist
      </v-btn>
      <v-btn flat v-if="!logged_in" v-on:click="login_user">
        Login
      </v-btn>
    </v-toolbar-items>
    <v-spacer></v-spacer>
    <v-toolbar-items class="hidden-sm-and-down" v-if="logged_in">
      <v-btn flat v-on:click="logout_user">
        Logout
      </v-btn>
    </v-toolbar-items>
    <v-toolbar-items class="hidden-sm-and-down" v-if="!logged_in">
      <v-btn flat v-on:click="login_client">
        Domain admin
      </v-btn>
      <v-btn flat v-on:click="login_admin">
        Platform admin
      </v-btn>
    </v-toolbar-items>
  </v-toolbar>
</template>

<script>
  export default {
    name: "Navigation",
    data: () => ({
      logged_in: false
    }),
    methods: {
      checkLoggedIn() {
        console.log("Current user for navigation: ",window.Constants.current_user);
        this.logged_in = this.loggedIn()
      },
      loggedIn() {
        return !(window === undefined || window.Constants === undefined || window.Constants.current_user === null);
      },
      isClient() {
        return this.loggedIn() && window.Constants.current_user.type === 'ClientUser'
      },
      isUser() {
        return this.loggedIn() && window.Constants.current_user.type === 'User'
      },
      isAdmin() {
        return this.loggedIn() && window.Constants.current_user.type === 'Admin'
      },
      login_admin() {
        this.$router.push({name: 'userlogin', params: {usertype: 'admin'}});
      },
      login_user() {
        this.$router.push({name: 'userlogin', params: {usertype: 'user'}});
      },
      login_client() {
        this.$router.push({name: 'userlogin', params: {usertype: 'client'}});
      },
      logout_user() {
        this.$root.$logout()
      }

    },
    components: {
    },
    mounted: function () {
      this.checkLoggedIn();
      this.$root.$on('login-changed',this.checkLoggedIn)
    }
  }
</script>

<style scoped>

</style>