$ ->
  ready = ->
    ex = document.getElementById('dns_zones')
    
    if !$.fn.DataTable.fnIsDataTable( ex )
        $('#dns_zones').dataTable(
            "order": [[ 0, "asc" ]]
            "columnDefs": [
                { "width":"20%", "targets" :0 },
                { "width":"20%", "targets" :1 },
                { "width":"10%", "targets" :2 },
                { "orderable": false, "targets": [2,3] }
                ]
            )
        
  $(document).ready(ready)
