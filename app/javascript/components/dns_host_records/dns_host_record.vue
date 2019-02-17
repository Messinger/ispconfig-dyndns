<template>
    <div id="dns_host_record_display">
        <h2>Record ID {{id}}</h2>
    </div>
</template>

<script lang="coffee">
    export default {
        name: "dns_host_record",
        props: ['id'],
        mounted: () ->
            console.log "Record view #{this.id} mounted"
    }
</script>

<style scoped>

</style>