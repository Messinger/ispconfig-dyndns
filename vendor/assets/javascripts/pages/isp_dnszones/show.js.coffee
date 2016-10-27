$ ->
   
  ready = ->
    ex = document.getElementById('dnsrecordstable')
    if !$.fn.DataTable.fnIsDataTable( ex )
        $('#dnsrecordstable').dataTable(
            "order": [[ 0, "asc" ]]
            "columnDefs": [
                { "orderable": false, "targets": 3 }
                ]
            )
  
  $(document).ready ->
    ready()
    
