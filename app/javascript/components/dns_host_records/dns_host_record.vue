<template>
    <div id="dns_host_record_display">
        <v-breadcrumbs :items="br_items">
            <v-icon slot="divider">chevron_right</v-icon>
        </v-breadcrumbs>
            <v-card>
                <v-card-title primary-title>
                    <h3 v-if="id !== 'new' && record.name !== null">
                        {{record.name}}.{{record.dns_zone.name}}
                    </h3>
                </v-card-title>
                <v-card-text>
                    <v-form ref="recordform" v-model="valid" lazy-validation id="dnsrecordform">
                        <v-layout row>
                            <v-flex xs1>
                                <v-subheader>IPv4 Adress:</v-subheader>
                            </v-flex>
                            <v-flex xs3>
                                <v-text-field v-model="record.dns_host_ip_a_record.address">
                                </v-text-field>
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
            </v-card>
    </div>
</template>

<script>
    export default {
        name: "dns_host_record",
        props: ['id'],
        data: () => ({
            loading: true,
            readonly: true,
            isdialog: true,
            valid: false,
            record: {
                id: null,
                name: null,
                dns_zone: {
                  name: null
                },
                dns_host_ip_a_record: {
                    address: null
                },
                dns_host_ip_aaaa_record: {
                    address: null
                }
            },
            br_items: []
        }),
        mounted: function () {
            console.log("Record view "+this.id+" mounted");
            setTimeout(this.retrieve_record,50)
            this.br_items = [
                {
                    text: "Index",
                    disabled: false,
                    href: this.$router.resolve('/').href
                },{
                    text: "DNS Eintrage",
                    disabled: false,
                    href: this.$router.resolve('/dns-host-records').href
                }
            ]
        },
        methods: {
            async retrieve_record() {
                if(this.id !== 'new') {
                    console.log("Record");
                    let result = await this.axios.get('/dns_host_records/'+this.id);
                    console.log(result);
                    if(result.status === 200) {
                        this.record = result.data;
                        this.readonly = this.record.api_key === '';
                    }
                } else {
                    console.log("New record");
                    this.readonly = false
                }
            }
        }
    }
</script>

<style scoped>

</style>