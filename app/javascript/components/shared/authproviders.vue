<template>
    <div id="authproviderlist">
        <v-list>
            <v-list-tile v-for="provider in providerlist" @click="">
                <v-list-tile-action>
                    <v-icon>mdi-{{provider.icon}}</v-icon>
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
      }
    }
</script>

<style scoped>

</style>