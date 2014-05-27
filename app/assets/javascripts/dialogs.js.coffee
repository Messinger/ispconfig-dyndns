
@showResultDialog = (head,msg,func = undefined ,width,heigth) ->
    $('#resultdialog').remove()
    width = 530 if width is 'undefined'
    height = 300 if height is 'undefined'
    myButtons = {}
    myButtons[I18n.t("globals.close")] = () ->
      if func != undefined && $.isFunction(func)
        func()
      $(this).dialog("close")
    e = createDialog("resultdialog",myButtons,width,height)
    e.html('<div id="ajaxresult"></div>');
    d = $('#ajaxresult');
    e.dialog( "option", "title",head);
    d.html(msg);

@showBlockBox = (head,msg,buttons) ->
  showBlockBoxSize(head,msg,buttons,530, 300)

@showBlockBoxSize = (head,msg,buttons, height, width) ->
  $('#blockdialog').remove()
  if buttons == undefined
    myButtons = {}
  else
    myButtons = buttons
  e = createDialog("blockdialog",myButtons,height,width)
  $('#blockdialog').dialog({ dialogClass: 'no-close', closeOnEscape: false })
  e.html('<div id="ajaxblock"></div>')
  d = $('#ajaxblock')
  e.dialog( "option", "title",head)
  d.html(msg)

@yesnoDialog = (head,text,onyes,parameters) ->
    $('#yesnoDialog').remove()

    myButtons = [{
          text: I18n.t("globals.yestext")
          id: "okbutton"
          icons: {primary:"ui-icon-check"}
          click: () ->
            $(this).dialog("close")
            onyes(parameters)
        },{
          text: I18n.t("globals.notext")
          id: "okbutton"
          icons: {primary:" ui-icon-cancel"}
          click: () ->
            $(this).dialog("close")
        }]

    e = createDialog('yesnoDialog',myButtons,350,350)
    e.html('<div id="yesnocontent"></div>')

    e.dialog("option","title",head)
    d = $('#yesnocontent')
    d.html(text)

@createDialog = (divname,buttonset,width,height,title) ->
    e = $('#'+divname)
    if (e.length == 0 || e.is(':data(uiDialog)')==false)
        _width = width
        if (_width==0)
            _width = $(window).width()-20
        _height = height
        if (_height == 0)
            _height = $(window).height()-20

        if e.length == 0
          div = $('<div id="'+divname+'" style="margin:0 0px 0px 0;"></div>')
          bblock = $('#bodyblock')
          if (bblock.length != 0)
              bblock.prepend(div);
          else
              $('body').prepend(div);
          e = $('#'+divname);

        e.dialog({
            width: _width
            modal: true
            autoOpen: false
            height: _height
            hide:
                {
                    effect: 'blind'
                    duration: "fast"
                }
            show:
                {
                    effect: 'blind'
                    duration: "fast"
                }
            buttons: buttonset
            position: { my: "center", at: "center", of: $('body') }
            title: title
        })

    e.dialog('open')
