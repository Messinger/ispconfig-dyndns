<template>
    <div id="records">
        <h2>DnsRecords</h2>
        <ul v-if="!loading">
            <li v-for="record in records" :key = "record.id">{{record.name}}</li>
        </ul>
    </div>
</template>

<script>
    import axios from  "axios"
    export default {
        name: "dns_host_record",
        data: function () {
            return {
                loading: false,
                records: []
            }
        },
        mounted: function () {
            axios.defaults.headers.common['Accept'] = 'application/json'
            console.log("Retrieving data from server");
            this.fetchRecords();
        },
        methods: {
            async fetchRecords() {
                this.loading = true;
                let results = await axios.get('/dns_host_records',{responseType: 'json'});
                this.records = results.data;
                this.loading = false;
            }
        }
    }
</script>

<style scoped>

</style>