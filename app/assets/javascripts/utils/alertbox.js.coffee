( ($) ->
  

  class Alertbox
    markerClassName: 'hasAlertbox'
    uuid: new Date().getTime()
    PROP_NAME = 'alertbox'

    constructor: () ->
      @debug = false
      @_keyEvent = false
      @_mainDivId = 'alertbox'
      @_parent = undefined
      @_dispname = undefined
      @_classname = 'bg-error'
      @_text = ''
      @_hideafter = 6
      @_alerttimer = undefined
      @div
   
    _clear_timeout: () ->
      unless @_alerttimer == undefined
        clearTimeout(@_alerttimer)
        @_alerttimer = undefined
      return

    @_attachAlertbox: (target,options) ->
      @nodeName = target.nodeName.toLowerCase()
      if !target.id
        @uuid+=1
        target.id='ab'+@uuid
      box= $(target).data(PROP_NAME)
      if box == undefined
        box = new Alertbox()
        box._parent = target
        box._set_message_box_name()
        box._classname = "alertinfo"
        box._gen_alert_box()
        $(target).data(PROP_NAME,box)
      return box

    _set_message_box_name: () ->
      @_dispname = 'alertbox'
      if @_parent != undefined
        if @_parent.id == undefined
          @_dispname += "_"+this._parent.name
        else
          @_dispname += "_"+this._parent.id
      return @_dispname

    _gen_alert_box: () ->
      if @_parent != undefined
        pos = @_parent_pos()
      else
        pos = { left: $(document).width()/2 - 30, top: 0 }
      classes = 'alertbox '+( if @_classname!=undefined then @_classname else '')
      @div = $('#'+@_dispname)
      if @div.length == 0
        @div = $('<div id="'+@_dispname+'"></div>')
        @div.attr("class","alertbox "+( if @_classname!=undefined then @_classname else ''))
        $('body').prepend(@div)
      @div.css({left:pos.left,top:pos.top})
      abc = this
      @div.click (event) ->
        abc.hide_box()
      return @div

    hide_box: () ->
      if @div == undefined || @div.length == 0
        return
      @div.dequeue()
      @_clear_timeout()
      @div.fadeOut('fast')
      return

    _parent_pos: () ->
      oElement = @_parent
      pos = { left: 0, top: 0 }
      while (oElement != null)
        pos.top += oElement.offsetTop
        pos.left += oElement.offsetLeft
        oElement = oElement.offsetParent
      return pos

    show_box: (aText,timeout,classname) ->
      if @div == undefined || @div.length == 0
        @_gen_alert_box()
      else if @_parent != undefined
        pos = @_parent_pos()
        pos.top += $(@_parent).outerHeight()
        @div.css(
          left: pos.left
          top: pos.top
        )
      if classname == undefined
        @_classname = "bg-info"
      else
        @_classname = classname
      @_hideafter = timeout
      @_clear_timeout()
      @div.attr("class","alertbox "+@_classname)
      @div.html(aText)
      @div.css('z-index','19001')
      @div.fadeIn('fast')
      that = this
      if @_hideafter != undefined && @_hideafter > 0
        @div.queue () ->
          $(this).dequeue()
          d = $(this)
          that._alerttimer = setTimeout( () ->
            that.hide_box()
          , that._hideafter*1000
          )
      return

    print_error: (aText,timeout) ->
      @show_box(aText,timeout,"bg-danger")
      return
    print_warning: (aText,timeout) ->
      @show_box(aText,timeout,"bg-warning")
      return
    print_info: (aText,timeout) ->
      @show_box(aText,timeout,"bg-info")
      return
    print_success: (aText,timeout) ->
      @show_box(aText,timeout,"bg-success")
      return

  $.fn.alertbox = (options) ->
    if !this.length
      return this
    return Alertbox._attachAlertbox(this[0],options)


  window.Alertbox = Alertbox
) jQuery

