<template>
  <div id="isp_dns_zones">
    <v-card>
      <v-card-title primary-title>
        <div><h3>DNS Zonen in ISPConfig</h3></div>
      </v-card-title>
      <v-card-text>
        <v-data-table :headers="headers" :items="isp_dns_zones">
          <template slot="items" slot-scope="props">
            <tr>
              <td>{{props.item.id}}</td>
              <td>{{props.item.origin}}</td>
              <td >{{props.item.local_zone.name}}</td>
              <td>
                <v-tooltip top v-if="!props.item.local_zone.id">
                  <template #activator="data">
                    <v-btn v-on="data.on" v-if="!props.item.local_zone.id" flat icon @click="add_local_zone(props.item)">
                      <v-icon>mdi-plus</v-icon>
                    </v-btn>
                  </template>
                  <span>Erzeuge eine lokale Zuweisung</span>
                </v-tooltip>
                <v-tooltip top v-if="props.item.local_zone.id">
                  <template #activator="data">
                    <v-btn v-on="data.on" v-if="props.item.local_zone.id" flat icon @click="delete_local_zone(props.item)">
                      <v-icon>mdi-delete-outline</v-icon>
                    </v-btn>
                  </template>
                  <span>Entferne lokale Zuweisung mit allen Records</span>
                </v-tooltip>

                <v-tooltip top>
                  <template #activator="data">
                    <v-btn v-on="data.on" flat icon @click="show_records(props.item)">
                      <v-icon>fa-list</v-icon>
                    </v-btn>
                  </template>
                  <span>Zeige alle DNS Einträge</span>
                </v-tooltip>

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
    name: "isp_dns_zones"

    data: () ->
      {
        isp_dns_zones: []
        headers: [
          {
            text: "Id"
            align: 'left'
            value: 'id'
          }
          {
            text: 'Name'
            align: 'left'
            value: 'origin'
          }
          {
            text: 'Lokal verwendet als'
            align: 'left'
            value: 'local_zone.name'
            sortable: true
          }
          {
            text: '',
            sortable: false,
            value: 'id'
          }
        ]
      }

    mounted: () ->
      setTimeout(this.retrieve_zones,20)

    methods: {
        localzone_to_name: (zone) ->
          if !!zone
            zone.name
          else
            ''

        show_records: (item) ->
          that = this
          setTimeout(
              () ->
                that.$router.push({name: 'IspDnsZone', params: {id: item.id} })
            ,10
          )

        retrieve_zones: () ->
          that = this
          zones = await this.axios.get('/client/isp_dnszones').catch( (error) ->
            zones = {data: []}
          )
          this.isp_dns_zones = zones.data

        delete_local_zone: (item) ->
          console.log "Lösche zuweisung für ",item.local_zone
          that = this
          this.$root.$confirm('Lösche lokale DNS Zone',"Die Zone #{item.local_zone.name} mit allen Einträgen wirklich löschen?",{color: 'red'})
          .then( (confirm) ->
            return unless confirm
            that.axios.delete("/client/dns_zones/#{item.local_zone.id}").then( (response) ->
              that.$root.$toast.warn("DNS Zone \"#{item.local_zone.name}\" entfernt.")
              item.local_zone = {}
            ).catch( (error) ->
              that.$root.$toast.warn("DNS Zone #{item.local_zone.name} konnte nicht entfernt werden.")
            )
          )

        add_local_zone: (item) ->
          console.log "Neue lokale Zuweisung für ",item
          submitdata = {
            ispzone_id: item.id
          }
          that = this
          axios.post('/client/dns_zones/add_dnszone',submitdata).then( (result) ->
            dnszone = result.data
            item.local_zone = dnszone
            that.$root.$toast.info("Zone \"#{dnszone.name}\" angelegt")
          ).catch( (error) ->
            that.$root.$toast.error("Could not create zone")
          )
    }
  }
</script>

<style scoped>

</style>