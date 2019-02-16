  plugin = (Vue,axios) ->
    if plugin.installed
      return
    console.log "Install axios into Vue"
    plugin.installed = true

    Vue.axios = axios

    Object.defineProperties(Vue.prototype,{
      axios: {
        get: () -> axios
      }
    })

  if typeof exports == "object"
    module.exports = plugin
  else if typeof exports == "function" && define.amd
    define([],() -> plugin )
  else if window.Vue && window.axios
    console.log "Use global axios"
    Vue.use(plugin,window.axis)