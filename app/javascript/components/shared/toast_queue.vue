<template>
  <v-snackbar id="global_toast"
              v-model="notification"
              :bottom="toast.bottom"
              :color="toast.color"
              :left="toast.left"
              :multi-line="toast.multiline"
              :right="toast.right"
              :timeout="toast.timeout"
              :top="toast.top"
              :vertical="toast.vertical"
  >
    {{toast.text}}
      <v-icon @click="notification = false">mdi-close</v-icon>
  </v-snackbar>
</template>

// https://github.com/vuetifyjs/vuetify/issues/2384
<script lang="coffee">
  export default {
    name: "toast_queue"

    data: () ->
      {
        toast: {
          text: 'I am a Snackbar !',
          color: 'info',
          timeout: 5000,
          top: true,
          bottom: false,
          right: false,
          left: false,
          multiline: false
          vertical: false
        }
        notificationQueue: [],
        notification: false
        ripple: false
      }
    computed: {

    }
    watch: {
        notification: () ->
          console.log "Aktuelle queue: ",this.notificationQueue
          if !this.notification && this.notificationQueue.length > 0
            this.toast = this.notificationQueue.shift()
            this.$nextTick(
              () ->
                this.notification = true
            )
    }
    methods: {
        hasNotificationPending: () ->
          this.notificationQueue.length > 0

        addNotification: (toast) ->
          return if typeof toast != 'object'
          this.notificationQueue.push(toast)
          unless this.notification
            this.toast = this.notificationQueue.shift()
            this.notification = true

        alert: (text) -> this.addNotification(this.makeToast(text,'error'))
        info: (text) -> this.addNotification(this.makeToast(text,'info'))
        success: (text) -> this.addNotification(this.makeToast(text,'success'))
        warn: (text) -> this.addNotification(this.makeToast(text,'warning'))

        makeToast: (text, color='info',timeout=6000,top=true,bottom=false,right = false, left = false, multiline = false, vertical = false) ->
          console.log text
          {
            text,
            color,
            timeout,
            top,
            bottom,
            right,
            left,
            multiline,
            vertical
          }
    }
  }
</script>

<style scoped>

</style>