$ ->
   
  ready = ->
    ex = document.getElementById('dnsrecords')
    if !$.fn.DataTable.fnIsDataTable( ex )
        $('#dnsrecords').dataTable(
            "order": [[ 0, "asc" ]]
            "columnDefs": [
                { "orderable": false, "targets": 3 }
                ]
            )
  
  $(document).ready ->
    ready()
    