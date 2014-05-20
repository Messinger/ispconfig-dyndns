$ ->
  ready = ->
    ex = document.getElementById('dns_zones')
    
    if !$.fn.DataTable.fnIsDataTable( ex )
        $('#dns_zones').dataTable(
            "order": [[ 0, "asc" ]]
            "columnDefs": [
                { "width":"20%", "targets" :1 },
                { "orderable": false, "width":"20%", "targets": 2 }
                ]
            )
  $(document).ready(ready)
