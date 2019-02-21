<template>
  <div id="authproviderlist">
    <v-list>
      <v-list-tile v-for="provider in providerlist" :key="provider.name">
        <v-list-tile-action>
          <v-icon @click="oauth(provider.path)">mdi-{{provider.icon}}</v-icon>
        </v-list-tile-action>
      </v-list-tile>
    </v-list>
    <v-dialog v-model="lockdialog" persistent>
      <v-container align-center justify-center  row fill-height><v-btn @click="login_window_focus">Hole das Authfenster zurück</v-btn></v-container>
    </v-dialog>
  </div>
</template>

<script lang="coffee">
  export default {
    name: "authproviders"
    data: () ->
      {
        lockdialog: false
        providerlist: []
        initialized: false
        promise: null
        reject: null
        authwindow: null
      }

    mounted: () ->
      this.check_providers()

    methods: {
      check_providers: () ->
        return if this.initialized
        that = this
        this.initialized = true
        retrieved = true
        providers = await this.axios.get('/users/providers').catch( (error) ->
          retrieved = false
          providers = {data: []}
        )
        console.log "Auth providers: ",providers.data
        this.providerlist = if retrieved then providers.data else []

      oauth: (url) ->
        this.begin_login(url)

      begin_login: (url) ->
        console.log window.$cookies.keys()
        window.$cookies.set("OAUTH-JSON-LOGIN",'1')
        this.lockdialog = true
        user = await this.open_login_window(url,"Connect to my site",800,600)
        this.lockdialog = false
        console.log "Got user via await: ",user
        window.$cookies.remove("OAUTH-JSON-LOGIN")
        if !!user && !!user.data
          window.Constants.current_user = user.data.account
          this.$root.$login_changed()

      login_window_focus: () ->
        this.authwindow.focus() if !!this.authwindow && !this.authwindow.closed

      open_login_window: (url,title,width,height) ->
        that = this
        left = screen.width / 2 - width/2
        top = screen.height / 2 - height / 2
        this.authwindow = window.open url,title,"location=0,status=0,width=#{width},height=#{height},top=#{top},left=#{left}"
        interval = setInterval( () ->
          if that.authwindow.closed
            clearInterval(interval)
            that.authwindow = null
            user = await that.axios.get('/users/fetch_user').catch(
              (errors) ->
                that.reject({})
                console.log errors
            )
            if user == undefined
              that.reject({})
            else
              that.resolve(user)

        , 500
        )
        new Promise( (resolve,reject) ->
          that.resolve = resolve
          that.reject = reject
        )
    }
  }
</script>

<style scoped>

</style>