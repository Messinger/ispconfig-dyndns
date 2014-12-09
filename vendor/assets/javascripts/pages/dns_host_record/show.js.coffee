$ ->
  
  edit_record = (event,source) ->
    event.preventDefault()
    f = $('form[id^="edit_dns_host_record"]')
    res = f.stringifyFormJSON()
    method = f.attr('method')
    console.log res+" via "+method+" to "+f.attr('action')
    $.ajax {
      url: f.attr('action')
      type: "PATCH"
      data:res
      contentType: "application/json; charset=utf-8"
      dataType: "json"
      success: (data,stat,xhr) ->
        console.log data
      error: (data,stat,xhr) ->
        console.log data
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
  
