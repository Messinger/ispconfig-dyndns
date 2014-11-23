$ ->
  
  edit_record = (event,source) ->
    event.preventDefault()
 
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
          primary: "ui-icon-pencil"
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
  
