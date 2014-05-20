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

  $(document).ready(ready)
  # turbolinks workaround
  $(document).on('page:load', ready)

