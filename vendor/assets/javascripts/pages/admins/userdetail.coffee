$ ->

  ready = ->
    $('#user_dns_hosts_list').DataTable(
      createdRow: (row,data) ->
        console.log data
    )

  $(document).ready(ready)