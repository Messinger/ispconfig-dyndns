<template>
    <div id="userview">
        <v-card v-if="displayuser!==null">
            <v-toolbar color="white" flat>
                <v-btn icon light @click="this.closedetail">
                    <v-icon color="grey darken-2">arrow_back</v-icon>
                </v-btn>
            </v-toolbar>
            <v-card-title><span class="title" font-weight-light>Benutzerdetails</span></v-card-title>
            <v-card-text>
                <v-card>
                    <v-container fluid grid-list-xs>
                        Email: {{displayuser.email}}
                    </v-container>
                    <v-container fluid grid-list-xs>
                        <div v-if="displayuser.identity !== null">
                            {{displayuser.identity.provider}}
                        </div>
                        <div v-else>
                            Intern
                        </div>
                    </v-container>
                </v-card>
            </v-card-text>
            <v-card-actions>
                <v-btn icon light @click="closedetail">
                    <v-icon color="grey darken-2" >arrow_back</v-icon>
                </v-btn>
            </v-card-actions>
        </v-card>
    </div>
</template>

<script lang="coffee">
    export default {
        name: "user"
        props: ['id']
        data: () ->
            {
                displayuser: null
            }
        mounted: () ->
            that = this
            setTimeout(this.fetchuser,10)
        methods: {
              closedetail: () ->
                  that = this
                  console.log "Go Back"
                  setTimeout(() ->
                            that.$router.push('/users')
                        , 20)
              ,
              fetchuser: () ->
                  userresponse = await this.axios.get('/admins/users/' + this.id).catch(
                          (error) ->
                              console.log error
                  )
                  if userresponse != null && userresponse != undefined
                      this.displayuser = userresponse.data

        }
    }
</script>

<style scoped>

</style>