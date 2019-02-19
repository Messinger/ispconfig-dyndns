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
                        <dl class="dl-horizontal">
                            <dt>Name</dt>
                            <dd>{{displayuser.name}}</dd>
                            <dt>Email</dt>
                            <dd>{{displayuser.email}}</dd>
                            <dt>Authorisierung</dt>
                            <dd v-if="displayuser.identity!==null">
                                {{displayuser.identity.provider}}
                            </dd>
                            <dd v-else>Intern</dd>
                            <dt>Seit</dt>
                            <dd>{{displayuser.created_at}}</dd>
                        </dl>
                    </v-container>
                </v-card>
            </v-card-text>
            <v-card v-if="displayuser!==null">
                <dns_host_records ref="records" :userid="displayuser.id"></dns_host_records>
            </v-card>
            <v-card-actions>
                <v-btn icon light @click="closedetail">
                    <v-icon color="grey darken-2" >arrow_back</v-icon>
                </v-btn>
            </v-card-actions>
        </v-card>
    </div>
</template>

<script lang="coffee">
    import dns_host_records from '../dns_host_records/dns_host_records'

    export default {
        name: "user"
        props: ['id']
        components: {
            dns_host_records: dns_host_records
        }
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