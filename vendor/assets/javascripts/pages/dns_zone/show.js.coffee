$ ->
  ready = ->
    ex = document.getElementById('dnszone_records')
    
    if !$.fn.DataTable.fnIsDataTable( ex )
        $('#dnszone_records').dataTable(
            "order": [[ 0, "asc" ]]
            "columnDefs": [
                { "width":"20%", "targets" :0 },
                { "width":"20%", "targets" :1 },
                { "orderable": false, "targets": 2 }
                ]
            )
  $(document).ready(ready)
