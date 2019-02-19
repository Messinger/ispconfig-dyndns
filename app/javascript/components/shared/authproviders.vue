<template>
    <div id="authproviderlist">
        <v-list>
            <v-list-tile v-for="provider in providerlist" :key="provider.name">
                <v-list-tile-action>
                    <v-icon @click="oauth(provider.path)">mdi-{{provider.icon}}</v-icon>
                </v-list-tile-action>
            </v-list-tile>
        </v-list>
    </div>
</template>

<script lang="coffee">
    export default {
      name: "authproviders"
      data: () ->
          {
              providerlist: []
              initialized: false
          }
      ,
      mounted: () ->
        this.check_providers()
      ,
      methods: {
          check_providers: () ->
              return if this.initialized
              that = this
              this.initialized = true
              retrieved = true
              providers = await this.axios.get('/users/providers').catch( (error) ->
                  console.log error
                  retrieved = false
              )
              console.log providers
              this.providerlist = if retrieved then providers.data else []
          ,
          oauth: (url) ->
              this.begin_login(url)
          ,
          begin_login: (url) ->
              this.open_login_window(url,"Connect to my site",800,600)
          ,
          open_login_window: (url,title,width,height) ->
              that = this
              left = screen.width / 2 - width/2
              top = screen.height / 2 - height / 2
              authwindow = window.open url,title,"location=0,status=0,width=#{width},height=#{height},top=#{top},left=#{left}"
              interval = setInterval( () ->
                  if authwindow.closed
                      clearInterval(interval)
                      user = await that.axios.get('/users/fetch_user').catch(
                              (errors) ->
                                  console.log errors
                      )
                      user = user.data
                      console.log user
                      window.Constants.current_user = user.account
                      that.$emit('login-changed', {})
              , 500
              )
      }
    }
</script>

<style scoped>

</style>