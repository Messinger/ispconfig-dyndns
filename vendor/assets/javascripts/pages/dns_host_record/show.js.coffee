$ ->
  
  edit_record = (event,source) ->
    event.preventDefault()
  
  ready = ->

    $(".editrecordbutton")
      .click (event) ->
        edit_record(event,this)
  
  $(document).ready(ready)
  