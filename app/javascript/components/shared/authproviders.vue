<template>
    <div id="authproviderlist">
        <v-list>
            <v-list-tile v-for="provider in providerlist">
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
              authwindow = this.open_login_window("#{url}?closewindow=true","Login to my site",800,600)
              interval = setInterval( () ->
                    if authwindow.closed
                        clearInterval(interval)
                        window.location = '/'
                , 500
              )
          ,
          open_login_window: (url,title,width,height) ->
              left = screen.width / 2 - width/2
              top = screen.height / 2 - height / 2
              window.open url,title,"location=0,status=0,width=#{width},height=#{height},top=#{top},left=#{left}"

      }
    }
</script>

<style scoped>

</style>