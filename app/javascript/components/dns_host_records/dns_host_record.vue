<template>
    <div id="dns_host_record_display">
        <v-breadcrumbs :items="br_items">
            <v-icon slot="divider">chevron_right</v-icon>
        </v-breadcrumbs>
        <v-card v-if="!this.loading">
            <v-card-title primary-title>
                <h3 v-if="id !== 'new' && record.name !== null">
                    {{record.name}}.{{record.dns_zone.name}}
                </h3>
            </v-card-title>
            <v-card-text>
                <v-form ref="form" v-model="valid" lazy-validation id="recordform">
                    <v-layout v-if="this.id === 'new'" row>
                        <v-flex xs1>
                            <v-subheader>Name:</v-subheader>
                        </v-flex>
                        <v-flex xs1>
                            <v-text-field v-model="record.name" suffix="." :rules="nameRules" label="Rechnername" required></v-text-field>
                        </v-flex>
                        <v-flex xs2>
                            <v-select
                                    v-model="record.dns_zone"
                                    :items="allowed_dns_zones"
                                    item-text="name"
                                    item-value="id"
                                    :rules="dnsRules"
                                    label="DNS Zone"
                                    required
                            >
                            </v-select>
                        </v-flex>
                    </v-layout>
                    <v-layout row>
                        <v-flex xs1>
                            <v-subheader>IPv4 Adress:</v-subheader>
                        </v-flex>
                        <v-flex xs3>
                            <v-text-field v-model="record.dns_host_ip_a_record.address"></v-text-field>
                        </v-flex>
                    </v-layout>
                    <v-layout row>
                        <v-flex xs1>
                            <v-subheader>IPv6 Adress:</v-subheader>
                        </v-flex>
                        <v-flex xs3>
                            <v-text-field v-model="record.dns_host_ip_aaaa_record.address"></v-text-field>
                        </v-flex>
                    </v-layout>
                </v-form>
            </v-card-text>
            <v-card-actions>
                <v-btn @click="validate_and_submit" flat color="success">Speichern</v-btn>
            </v-card-actions>
        </v-card>
    </div>
</template>

<script lang="coffee">
    export default {
        name: "dns_host_record"
        props: [
            'id'
        ]
        data: () ->
            {
                loading: true
                readonly: true
                isdialog: true
                valid: true
                default_values: {
                    id: null,
                    name: null,
                    dns_zone: {
                        name: null
                        id: null
                    }
                    dns_host_ip_a_record: {
                        address: null
                    }
                    dns_host_ip_aaaa_record: {
                        address: null
                    }
                }
                record: {}
                br_items: [
                ]
                allowed_dns_zones: [
                ]
                nameRules: [
                    (v) -> (!!v || "Name wird benötigt")
                    (v) -> ( (!!v && v.length <= 15) || 'Name sollte max. 15 Zeichen lang sein')
                ]
                dnsRules: [
                    (v) ->
                        !!v.id || !!Number.isInteger(v) || "Bitte Zone auswählen"
                ]
            }
        mounted: () ->
            console.log("Record view " + this.id + " mounted");
            setTimeout(this.retrieve_record, 50)
            this.allowed_dns_zones = []

            this.br_items = [
                {
                    text: "Index",
                    disabled: false,
                    href: this.$router.resolve('/').href
                }
                {
                    text: "DNS Einträge",
                    disabled: false,
                    href: this.$router.resolve('/dns-host-records').href
                }
            ]
        methods: {
            retrieve_record: () ->
                result = await this.axios.get('/dns_host_records/' + this.id)
                console.log(result)
                if result.status == 200
                    this.record = if this.id != 'new' then result.data else this.default_values
                    this.allowed_dns_zones = result.data.zoneselection if this.id == 'new'
                    this.readonly = (this.record.api_key == '' && this.record.id != null)
                this.loading = false

            validate_and_submit: () ->
                console.log "Validiere hostname"
                console.log this.record
                return unless this.$refs.form.validate()

                submitvalues = this.record
                if Number.isInteger(submitvalues.dns_zone)
                    submitvalues['dns_zone'] = {
                        id: submitvalues.dns_zone
                    }
                console.log submitvalues

                result = null

                this.axios.post('/dns_host_records',submitvalues).then((response) ->
                    result = response
                ).catch((error,xhr) ->
                    console.log error.response.data
                )

                console.log result
        }
    }
</script>

<style scoped>

</style>