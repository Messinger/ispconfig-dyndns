$ ->


  delete_user = () ->
    console.log window.location
    start_wait(undefined,1)
    $.ajax {
      url: window.location
      type: "DELETE"
      dataType: "json"
      data: undefined
      success: (data,status,xhr) ->
        stop_wait()
        window.location = window.user_index
      error: (req,msg,obj) ->
        stop_wait()
        console.log(req)
    }

  ask_delete_user = (event) ->
    yesnoDialog("Delete","Delete this user?",delete_user)

  ready = ->
    $('#user_dns_hosts_list').DataTable(
      createdRow: (row,data) ->
        console.log data
    )

  $(".deleteuserbutton").click (event) ->
    event.preventDefault()
    ask_delete_user(event)

  $(document).ready(ready)