<template>
    <div id="dns-records-container">
        <v-card v-if="!loading">
        <v-toolbar light>
            <v-toolbar-title>DNS Einträge</v-toolbar-title>
            <v-spacer></v-spacer>
            <v-text-field v-model="search" append-icon="search" label="Search" single-line hide-details></v-text-field>
            <v-menu v-if="isMobile" offset-y :nudge-left="170" :close-on-content-click="false">
                <v-btn icon slot="activator">
                    <v-icon>more_vert</v-icon>
                </v-btn>
                <v-list>
                    <v-list-tile  v-for="(item, index) in filter_headers()" :key="item.value" @click="changeSort(item.value)">
                        <v-list-tile-title>{{ item.text }}<v-icon v-if="pagination.sortBy === item.value">{{pagination.descending ? 'arrow_downward':'arrow_upward'}}</v-icon></v-list-tile-title>
                    </v-list-tile>
                </v-list>
            </v-menu>
        </v-toolbar>
        <v-card-text v-resize="onResize" style="padding-top:0.5em;">
            <v-data-table :headers="headers" :items="records" :search="search" :pagination.sync="pagination" :hide-headers="isMobile" :class="{mobile: isMobile}">
                <template slot="items" slot-scope="props">
                    <tr v-if="!isMobile" @dblclick="itemdblclick(props.item)">
                        <td>{{ props.item.full_name }}</td>
                        <td>{{ props.item.dns_host_ip_a_record.address}}</td>
                        <td>{{ props.item.dns_host_ip_aaaa_record.address}}</td>
                        <td>{{ props.item.api_key.access_token }}</td>
                        <td class="justify-center layout px-0">
                            <v-icon
                                    small
                                    class="mr-2"
                                    @click="itemdblclick(props.item)"
                            >
                                mdi-pencil-outline
                            </v-icon>
                            <v-icon
                                    small
                                    @click="deleteItem(props.item)"
                            >
                                mdi-trash-can-outline
                            </v-icon>
                        </td>
                    </tr>
                    <tr v-else>
                        <td>
                            <ul class="flex-content">
                                <li class="flex-item" data-label="Name">{{ props.item.full_name }}</li>
                                <li class="flex-item" data-label="IPv4">{{ props.item.dns_host_ip_a_record.address }}</li>
                                <li class="flex-item" data-label="IPv6">{{ props.item.dns_host_ip_aaaa_record.address }}</li>
                                <li class="flex-item" data-label="Token">{{ props.item.api_key.access_token }}</li>
                                <li class="flex-item">
                                    <v-icon
                                            small
                                            class="mr-2"
                                            @click="itemdblclick(props.item)"
                                    >
                                        edit
                                    </v-icon>
                                    <v-icon
                                            small
                                            @click="deleteItem(props.item)"
                                    >
                                        delete
                                    </v-icon>
                                </li>
                            </ul>
                        </td>
                    </tr>
                </template>
                <v-alert slot="no-results" :value="true" color="warning" icon="warning">
                    Your search for "{{ search }}" found no results.
                </v-alert>
            </v-data-table>
        </v-card-text>
            <v-card-text>
                <v-btn absolute
                       dark
                       fab
                       bottom
                       right
                       color="blue"
                       @click.native="newRecord"
                >
                    <v-icon>mdi-plus</v-icon>
                </v-btn>
            </v-card-text>
        </v-card>
    </div>
</template>

<script>

    export default {
        name: "dns_host_records",
        components: {
        },
        data: function () {
            return {
                loading: true,
                records: [],
                pagination: {
                    sortBy: 'full_name'
                },
                selected: [],
                search: '',
                isMobile: false,
                headers: [{
                  text: 'Hostname',
                  align: 'left',
                  value: 'full_name'
                },{
                    text: 'IPv4 Adress',
                    align: 'left',
                    value: 'dns_host_ip_a_record.address'
                },{
                    text: 'IPv6 Adress',
                    align: 'left',
                    value: 'dns_host_ip_aaaa_record.address'
                },{
                    text: 'Token',
                    align: 'left',
                    value: 'api_key.access_token'
                },{
                    text: '',
                    sortable: false,
                    value: 'id'
                }]
            }
        },
        mounted: function () {
            console.log("start Retrieving data from server");
            setTimeout(this.fetchRecords,50);
        },
        methods: {
            filter_headers() {
              return this.headers.filter(function (e) {
                 return e.sortable !== false
              });
            },
            async fetchRecords() {
                console.log("Fetch them")
                this.loading = true;
                let results = await this.axios.get('/dns_host_records');
                this.records = results.data;
                this.loading = false;
            },
            onResize() {
                this.isMobile = window.innerWidth < 769
            },
            toggleAll() {
                if (this.selected.length) this.selected = [];
                else this.selected = this.records.slice();
            },
            changeSort(column) {
                console.log(column);
                if (this.pagination.sortBy === column) {
                    this.pagination.descending = !this.pagination.descending;
                } else {
                    this.pagination.sortBy = column;
                    this.pagination.descending = false;
                }
            },
            itemdblclick(item) {
                this.$router.push('/dns-host-records/'+item.id)
            },
            newRecord() {
                let that = this;
                setTimeout(
                  function() {
                      that.$router.push('/dns-host-records/new')
                  },10

                )
            },
            deleteItem(item) {
                let that = this
                console.log(item)
                this.$root.$confirm('Lösche Eintrag',"Dein Eintrag "+item.name+"."+item.dns_zone.name+" wirklich löschen?",
                    { color: 'red' }
                    ).then(async (confirm) => {
                        if(confirm) {
                            console.log("Ok, löschen wir mal ")
                            that.$root.$spinner.open()
                            await that.axios.delete("/dns_host_records/"+item.id).then(function (response) {
                                setTimeout(that.fetchRecords,50);
                            }).catch( function(error) {
                                console.log(error)
                            })
                            that.$root.$spinner.close()
                        }
                    })
            }
        }
    }
</script>

<style scoped>
    .mobile {
        color: #333;
    }

    @media screen and (max-width: 768px) {
        .mobile table.v-table tr {
            max-width: 100%;
            position: relative;
            display: block;
        }

        .mobile table.v-table tr:nth-child(odd) {
            border-left: 6px solid deeppink;
        }

        .mobile table.v-table tr:nth-child(even) {
            border-left: 6px solid cyan;
        }

        .mobile table.v-table tr td {
            display: flex;
            width: 100%;
            border-bottom: 1px solid #f5f5f5;
            height: auto;
            padding: 10px;
        }

        .mobile table.v-table tr td ul li:before {
            content: attr(data-label);
            padding-right: .5em;
            text-align: left;
            display: block;
            color: #999;

        }
        .v-datatable__actions__select
        {
            width: 50%;
            margin: 0px;
            justify-content: flex-start;
        }
        .mobile .theme--light.v-table tbody tr:hover:not(.v-datatable__expand-row) {
            background: transparent;
        }

    }
    .flex-content {
        padding: 0;
        margin: 0;
        list-style: none;
        display: flex;
        flex-wrap: wrap;
        width: 100%;
    }

    .flex-item {
        padding: 5px;
        width: 50%;
        height: 40px;
        font-weight: bold;
    }
</style>