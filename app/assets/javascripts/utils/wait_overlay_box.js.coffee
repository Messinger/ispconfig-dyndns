( ($) ->

  class WaitOverlayBox

    @DIVID: "wait-overlay-box"
    PROP_NAME = 'wait_box'
    @uuid: new Date().getTime()

    @get_standard_instance: (target,options = {}) ->
      @nodeName = target.nodeName.toLowerCase()
      waitbox = $(target).data(PROP_NAME)
      if options['waitboxid'] == undefined
        if !target.id
          WaitOverlayBox.uuid+=1
          boxid="wait_"+@uuid
        else
          boxid = "wait_"+target.id
        options['waitboxid'] = boxid

      if waitbox == undefined
        waitbox = new WaitOverlayBox(options['waitboxid'])
        $(target).data(PROP_NAME,waitbox)
      return waitbox

    constructor: (@boxdivid = WaitOverlayBox.DIVID) ->
      @current_box = $('#'+@boxdivid)
      @display_timer = undefined
      @waittimer = undefined
      if @current_box.length == 0
        div = $('<div id="'+@boxdivid+'"><div class="wait_message_text" style="font-size: large;"></div><div class="loadingscreen_content"></div></div>')
        $('body').prepend(div)
        @current_box = $('#'+@boxdivid)

      if @current_box.is(':data(uiDialog)')==false
        @current_box.dialog ({
          autoOpen: false
          closeOnEscape: false
          modal: true
          width: "auto"
          height: "auto"
          minHeight: 0
          minWidth: 0
          resizeable: false
          dialogClass: 'loadingScreenWindow no-dialog-padding'

        })

    _clear_timeout: () ->
      unless @display_timer == undefined
        clearTimeout(@display_timer)
        @display_timer = undefined
      return

    display: () ->
      _msgspan = $(@current_box).find('.wait_message_text')
      _imgdiv = $(@current_box).find('.loadingscreen_content')
      _msgspan.html(@message)
      $(@current_box).dialog('open')
      if @message.length > 0
        _msgspan.css("margin","10px")
        _imgdiv.css("margin-bottom","10px")
      else
        _msgspan.css("margin","0px")
        _imgdiv.css("margin-bottom","0px")
      return

    show: (@message = "",after = 0) ->
      that = this
      @_clear_timeout()
      if after > 0
        @display_timer = setTimeout( () ->
          that.display()
          return
        , after*1000)
      else
        that.display()
      return

    hide: () ->
      @_clear_timeout()
      $(@current_box).dialog('close')
      return
 
  $.fn.waitbox = (options) ->
    if !this.length
      return this
    return WaitOverlayBox.get_standard_instance(this[0],options)

) jQuery

$ ->
  window.start_wait = (message,after) ->
    $('body').waitbox().show(message,after)
  window.stop_wait = () ->
    $('body').waitbox().hide()



