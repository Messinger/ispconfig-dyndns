$ ->

  class ajax_error_handler
    
    constructor: (@jqxhr = undefined,@event = undefined) ->
      @callback = undefined

    @get_instance = (errorcode,jqxhr,event) ->
      switch errorcode
        when 401,"401" then return new ajax_401_error(jqxhr,event)
        else return undefined

    do_action: () ->
      @callback() unless @callback == undefined
      return

  class ajax_401_error extends ajax_error_handler

    constructor: (jqxhr,event) ->
      super(jqxhr,event)
      @callback = this.display_and_logout


    display_and_logout: () ->
      that = this
      bs = [
        {
          id: "button-close"
          text: I18n.t("globals.back_to_login_page")
          click: (event) ->
            event.preventDefault()
            $(this).dialog("close")
            window.location = window.Constants.LOGIN_PATH
            return
        }
      ]
      showBlockBox(I18n.t("globals.session_is_invalid"),that.jqxhr.statusText,bs)
      return

  window.ajax_error_handler = ajax_error_handler

  $.ajaxSetup {
    headers:
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
  }

  $(document).ajaxSend (event, jqxhr, settings) ->
#    console.log "Sending ajax"
#    console.log settings
    return

  $(document).ajaxError (event, jqxhr, settings, thrownError) ->
    eh = ajax_error_handler.get_instance(jqxhr.status,jqxhr,event)
    console.log eh
    eh.do_action() unless eh == undefined
    return

  return
  
