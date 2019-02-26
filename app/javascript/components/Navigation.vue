<template>
  <v-toolbar >
    <v-toolbar-side-icon></v-toolbar-side-icon>
    <v-toolbar-title>Dyndns</v-toolbar-title>
    <v-toolbar-items class="hidden-sm-and-down">
      <v-btn flat to="/">
        Home
      </v-btn>
      <v-btn flat :to="{name: 'dns_host_records'}" v-if="valid_user">
        DNS Einträge
      </v-btn>
      <v-menu offset-y open-on-hover v-if="is_client">
        <v-btn flat slot="activator">
          Zonen Verwaltung
        </v-btn>
        <v-list>
          <v-list-tile :to="{name: 'IspDnsZones'}">
            <v-list-tile-title>ISPConfig DNS-Zonen </v-list-tile-title>
          </v-list-tile>
          <v-list-tile :to="{name: 'DnsZones'}">
            <v-list-tile-title>Lokale DNS Zonen</v-list-tile-title>
          </v-list-tile>
          <v-list-tile  :to="{name: 'dns_host_records'}">
            Lokale DNS Einträge
          </v-list-tile>
        </v-list>
      </v-menu>
      <v-btn flat :to="{name: 'admin_userlist'}" v-if="is_admin">
        Userlist
      </v-btn>
      <v-btn flat :to="{name: 'app_settings'}" v-if="is_admin">
        Application Settings
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
      logged_in: false,
      valid_user: false,
      is_user: false,
      is_client: false,
      is_admin: false,
      user_locked: false,
      user_not_verified: false
    }),
    methods: {
      checkLoggedIn() {
        this.logged_in = this.loggedIn();
        this.valid_user = this.isValidUser();
        this.is_user = this.isUser();
        this.is_client = this.isClient();
        this.is_admin = this.isAdmin();
        this.user_locked = this.logged_in && !!this.current_user().locked;
        this.user_not_verified = this.logged_in && !!this.current_user().email_must_verified;
      },
      current_user() {
        return this.$root.$current_user();
      },
      loggedIn() {
        return !!this.$root.$current_user();
      },
      isClient() {
        return this.logged_in && this.current_user().type === 'ClientUser'
      },
      isUser() {
        return this.loggedIn() && this.current_user().type === 'User'
      },
      isValidUser() {
        return this.isUser() && !this.current_user().locked && !this.current_user().email_must_verified
      },
      isAdmin() {
        return this.loggedIn() && this.current_user().type === 'Admin'
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
      console.log("Mount navigation");
      this.checkLoggedIn();
      this.$root.$on('login-changed',this.checkLoggedIn)
    }
  }
</script>

<style scoped>

</style>