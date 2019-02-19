<template>
    <div id="users_container">
        <v-card>
            <v-card-title><span class="title" font-weight-light>Bekannte Benutzer</span></v-card-title>
            <v-card-text>
                <v-data-table :headers="headers" :items="records">
                    <template slot="items" slot-scope="props">
                        <tr @dblclick="showUser(props.item)">
                            <td>{{ props.item.id }}</td>
                            <td>{{ props.item.email}}</td>
                            <td>{{ props.item.identity.provider}}</td>
                            <td>{{ props.item.dns_host_records.length}}</td>
                            <td class="justify-center layout px-0">
                                <v-icon
                                        small
                                        class="mr-2"
                                        @click="showUser(props.item)"
                                >
                                    mdi-pencil-outline
                                </v-icon>
                                <v-icon
                                        small
                                        @click="showUser(props.item)"
                                >
                                    mdi-trash-can-outline
                                </v-icon>
                            </td>
                        </tr>
                    </template>
                </v-data-table>
            </v-card-text>
        </v-card>
    </div>
</template>

<script lang="coffee">
    export default {
        name: "users"
        data: () ->
            {
              records: []
              pagination: {
                sortBy: 'id'
              }
              search: ''
              headers: [{
                text: "Id"
                align: "left"
                value: "id"
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
            ,
            showUser: (useritem) ->
                console.log "Show user id"
                console.log useritem
        }
    }
</script>

<style scoped>

</style>