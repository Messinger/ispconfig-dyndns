<template>
  <div id="users_container">
    <v-card v-if="displayuser === null">
      <v-card-title>
        <span class="title" font-weight-light>Bekannte Benutzer</span>
        <v-spacer></v-spacer>
        <v-btn icon flat @click="fetchRecords">
          <v-icon>mdi-refresh</v-icon>
        </v-btn>
      </v-card-title>
      <v-card-text>
        <v-data-table :headers="headers" :items="records">
          <template slot="items" slot-scope="props">
            <tr @dblclick="showUser(props.item)">
              <td>{{ props.item.id }}</td>
              <td>{{ props.item.name }}</td>
              <td>{{ props.item.email}}</td>
              <td v-if="props.item.identity !== null">{{ props.item.identity.provider}}</td>
              <td v-else>Intern</td>
              <td>{{ props.item.dns_host_records.length}}</td>
              <td>
                <v-checkbox hide-details v-model="props.item.locked" label="" disabled></v-checkbox>
              </td>
              <td class="justify-center layout px-0">
                <v-icon
                    small
                    class="mr-2"
                    @click="showUser(props.item)"
                >
                  mdi-account-details
                </v-icon>
                <v-icon
                    small
                    @click="deleteUser(props.item)"
                >
                  mdi-trash-can-outline
                </v-icon>
              </td>
            </tr>
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>
    <v-card v-else>
      <v-toolbar color="white" flat>
        <v-btn icon light  @click="closedetail">
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
          <v-icon color="grey darken-2">arrow_back</v-icon>
        </v-btn>
      </v-card-actions>
    </v-card>
  </div>
</template>

<script lang="coffee">
  export default {
    name: "users"
    data: () ->
      {
        displayuser: null
        records: []
        pagination: {
          sortBy: 'name'
        }
        search: ''
        headers: [{
          text: "Id"
          align: "left"
          value: "id"
        },{
          text: "Name"
          align: "left"
          value: "name"
        },{
          text: "Email"
          align: "left"
          value: "email"
        },{
          text: "Angemeldet via"
          align: "left"
          value: "identity.provider"
        },{
          text: "Anzahl DNS Records"
          align: "left"
          value: "dns_host_records.length"
        },{
          text: 'Locked',
          sortable: false,
          value: 'locked'
        },{
          text: '',
          sortable: false,
          value: 'id'
        }]
      }
    mounted: () ->
      setTimeout(this.fetchRecords,50);
    methods: {
      fetchRecords: () ->
        results = await this.axios.get('/admins/users').catch(
          (error) ->
            console.log errors
        );
        this.records = results.data;

      showUser: (useritem) ->
        console.log "Show user id"
        console.log useritem
        this.$router.push({name: 'admin_userdetail', params: {id: useritem.id} })
        #this.displayuser = useritem

      deleteUser: (useritem) ->
        that = this
        this.$root.$confirm('Lösche Benutzer',"Dein Benutzer #{useritem.email} wirklich löschen?",{color: 'red'})
          .then(
            (confirm) ->
              return unless confirm
              that.$root.$spinner.open()
              console.log "Wirklich löschen..."
              await that.axios.delete("/admins/users/#{useritem.id}").then(
                  (response) ->
                    setTimeout(that.fetchRecords,20)
              ).catch(
                  (error) ->
                    console.log error
              )
              that.$root.$spinner.close()

        )

      closedetail: () ->
        console.log "Verstecke benutzerdetails"
        that = this
        setTimeout( () ->
          that.displayuser = null
        , 10
        )
    }
  }
</script>

<style scoped>

</style>