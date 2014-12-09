$ ->
  
  edit_record = (event,source) ->
    event.preventDefault()
    f = $('form[id^="edit_dns_host_record"]')
    res = f.stringifyFormJSON()
    method = f.attr('method')
    $.ajax {
      url: f.attr('action')
      type: "PATCH"
      data:res
      contentType: "application/json; charset=utf-8"
      dataType: "json"
      success: (data,stat,xhr) ->
        $('[id^="edit_dns_host_record"]').alertbox().print_success("saved",5)
        return
      error: (data,stat,xhr) ->
        errors = data.responseJSON
        for sub,val of errors
          if typeof val == 'object'
            for key,text of val
              ele = $('#'+sub+"_"+key)
              unless ele.length == 0
                ele.alertbox().print_error(text,10)
        return
    }
 
  ask_delete_record = (event,source) ->
    event.preventDefault()
    yesno = yesnoDialog("Delete","Delete this record?",delete_record)


  delete_record = ->
    $.ajax {
      url: recordurl
      type: "DELETE"
      data: undefined
      success: (data,status,xhr) ->
        window.location.href = window.listurl
        return
      error: (req,msg,obj) ->
        console.log(req)
    }

  ready = ->

    $(".editrecordbutton")
      .button ({
        icons: {
          primary: "ui-icon-disk"
        }
        text: false
      })
      .click (event) ->
        edit_record(event,this)

    $("a.deleterecordbutton").not('.ui-button')
      .button({
          icons: {
              primary: "ui-icon-trash"
                  }
          text: false
          })
      .click (event) ->
        ask_delete_record(event,this)

  
  $(document).ready(ready)
  
