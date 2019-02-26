<template>
  <div id="client-dns-zones">
    <v-card>
      <v-card-title primary-title>
        <h3>Lokale DNS Zonen</h3>
      </v-card-title>
      <v-card-text>
        <v-data-table :headers="headers" :items="dns_zones">
          <template slot="items" slot-scope="props">
            <tr>
              <td>{{props.item.name}}</td>
              <td>{{props.item.assigned_records_count}}</td>
              <td>
                <v-checkbox hide-details v-model="props.item.is_public" label=""
                            @click.native="toggle_public(props.item)"></v-checkbox>
              </td>
              <td>
                <v-btn flat icon @click="show_ispconfig(props.item)">
                  <v-icon>mdi-dns</v-icon>
                </v-btn>
                <v-btn flat icon :to="{name: 'dns_host_records',params: { zone_id: props.item.id }}">
                  <v-icon>mdi-reorder-horizontal</v-icon>
                </v-btn>
                <v-tooltip top>
                  <template #activator="data">
                    <v-btn v-on="data.on" flat icon @click="delete_local_zone(props.item)">
                      <v-icon>mdi-delete-outline</v-icon>
                    </v-btn>
                  </template>
                  <span>Entferne lokale Zone mit allen Records</span>
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
    name: "dns_zones"

    data: () ->
      {
        dns_zones: []
        headers: [
          {
            text: "Name"
            align: "left"
            value: "name"
          }
          {
            text: "Zugewiesene Einträge"
            align: "left"
            value: "assigned_records_count"
          }
          {
            text: "Allgemein benutzbar"
            align: "left"
            value: "is_public"
          }
          {
            text: ''
            align: 'left'
            value: ''
            sortable: false
          }
        ]
      }
    mounted: () ->
      console.log "Mount dnszones"
      this.fetch_dns_zones()

    methods: {
      fetch_dns_zones: () ->
        that = this
        this.axios.get('/client/dns_zones').then(
          (result) ->
            that.dns_zones = result.data
            console.log "DNS-Zonen: ", result.data
        ).catch(
          (error) ->
            that.$root.$toast.error(error.data)
            that.dns_zones = []
        )

      toggle_public: (item) ->
        console.log "Schalte public um für ", item
        that = this
        if !item.is_public
          this.$root.$confirm('Verstecke DNS Zone',
              "Die Zone #{item.name} wirklich verstecken? (es werden keine Einträge gelöscht)",
              {color: 'red'}).then(
                (confirm) ->
                  if confirm
                    that.real_toggle_public(item)
                  else
                    item.is_public = true
          )
        else
          this.real_toggle_public(item)

      real_toggle_public: (item) ->
        that = this
        params = {
          dns_zone: {
            is_public: !!item.is_public
          }
        }

        this.axios.put("/client/dns_zones/#{item.id}", params).then(
          (result) ->
            that.fetch_dns_zones()
        ).catch(
          (error) ->
            that.$root.$toast.error(error.data)
            that.fetch_dns_zones()
        )


      show_ispconfig: (item) ->
        that = this
        setTimeout(
          () ->
            that.$root.$router.push({name: 'IspDnsZone', params: {id: item.isp_dnszone_id}})
        , 20
        )

      show_records: (item) ->
        that = this
        setTimeout(
          () ->
            that.$root.$router.push({name: 'dns_host_records', params: {zone_id: item.id}})
        , 20
        )

      delete_local_zone: (item) ->
        console.log "Delete zone ", item
        that = this
        this.$root.$confirm('Verstecke DNS Zone',
            "Die Zone \"#{item.name}\" wirklich mit allen Einträgen löschen?", {color: 'red'})
          .then(
            (confirm) ->
              if confirm
                that.axios.delete("/client/dns_zones/#{item.id}").then(
                    (result) ->
                      that.fetch_dns_zones()
                ).catch(
                    (error) ->
                      that.$root.$toast.error(error.data)
                      that.fetch_dns_zones()
                )
        )
    }
  }
</script>

<style scoped>

</style>