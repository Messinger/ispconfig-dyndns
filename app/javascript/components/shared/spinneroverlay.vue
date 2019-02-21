<template>
  <v-dialog v-model="dialog" v-bind:style="{zIndex: 200}" persistent width="60">
    <v-card color="white">
      <v-card-text color="transparent">
        <v-progress-circular
            indeterminate
            color="black"
        ></v-progress-circular>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script lang="coffee">
  export default {
    name: "spinneroverlay"
    data: () ->
      {
        dialog: false
      }
    methods: {
      open: () ->
        this.dialog = true

      close: () ->
        this.dialog = false
    }
  }
</script>

<style scoped>
  .transparent {
    background-color: white!important;
    opacity: 0.01;
    border-color: transparent!important;
  }
</style>