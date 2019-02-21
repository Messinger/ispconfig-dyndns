<template>
  <div id="isp_dns_zone_view">
    <v-card>
      <v-card-title primary-title>
        <v-progress-circular
            indeterminate
            color="black"
            v-if="!zoneinfo.origin"
        ></v-progress-circular>
        <div v-if="!!zoneinfo.origin"><h3>Details von {{zoneinfo.origin}}</h3></div>
      </v-card-title>
      <v-card-text>
        <v-toolbar light flat>
          <v-spacer></v-spacer>
          <v-text-field v-model="search" append-icon="search" label="Search" single-line hide-details></v-text-field>
        </v-toolbar>
        <v-data-table :headers="headers" :items="records" :search="search" :pagination.sync="pagination">
          <template slot="items" slot-scope="props">
            <tr>
              <td>{{props.item.name}}</td>
              <td><div>{{props.item.type}}</div></td>
              <td>
                <v-tooltip top>
                  <template #activator="data">
                    <div v-on="data.on" class="ellipsistxt">{{props.item.data}}</div>
                  </template>
                  <div style="max-width: 20em; word-break: break-all;">{{props.item.data}}</div>
                </v-tooltip>
              </td>
              <td>
                <a :href="get_item_url(props.item)" v-if="!!props.item.local_host_rec.id">{{props.item.local_host_rec.name}}</a>
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
    props: ['id']
    name: "isp_dns_zone"
    data: () ->
      {
        zoneinfo: {}
        records: []
        headers: [
          {
            text: 'Name'
            value: 'name'
          }
          {
            text: 'Type'
            value: 'type'
          }
          {
            text: 'Eintrag'
            value: 'data'
          }
          {
            text: "Lokale Zuweisung"
            value: "local_host_rec.id"
          }
        ]
        pagination: {
          sortBy: 'name'
        }
        search: ''
      }

    mounted: () ->
      setTimeout(this.fetchdata,10)

    methods: {
      fetchdata: () ->
        that = this
        zonedata = await this.axios.get("/client/isp_dnszones/#{this.id}").catch(
            (error) ->
              console.log error
              that.zoneinfo = {}
              that.records = []
        )
        if !!zonedata
          this.zoneinfo = zonedata.data.zone
          this.records = zonedata.data.records

      get_item_url: (item) ->
        this.$router.resolve({name: 'dns_host_record',params:{id: item.local_host_rec.id}}).href
    }
  }
</script>

<style scoped>
  .ellipsistxt {
    max-width: 20em;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
  }
</style>