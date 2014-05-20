$ ->
  
  ready = ->
    ex = document.getElementById('ispdnszones')

    if !$.fn.DataTable.fnIsDataTable( ex )
        $('#ispdnszones').dataTable(
            "order": [[ 0, "asc" ]]
            "columnDefs": [
                { "orderable": false, "targets": 2 }
                ]
            )

    $('.add-dns-zone').click (event) ->
        event.preventDefault()
        id = $(this).data("ispzoneid")
        if id == undefined
            return
        url = add_zone_path
        data = "{\"ispzone_id\": \""+id+"\"}"
        console.log data
        $.ajax {
            url: url
            type: 'POST'
            contentType: "application/json; charset=utf-8"
            dataType: "json"
            data: data
            success: (data,status,xhr) ->
                window.location.reload()
            error: (req,msg,ojb) ->
                console.log(req)
            }

    $('.drop-dns-zone').click (event) ->
        event.preventDefault()
        url = $(this).data("dropurl")
        $.ajax {
            url: url
            type: "DELETE"
            contentType: "application/json; charset=utf-8"
            dataType: "json"
            data: undefined
            success: (data,status,xhr) ->
                window.location.reload()
            error: (req,msg,ojb) ->
                console.log(req)        
        }
    
  $(document).ready(ready)

