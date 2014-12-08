$ ->

  ready = ->
    ex = document.getElementById('admin_user_list')
    if !$.fn.DataTable.fnIsDataTable(ex)
      $(ex).dataTable(
        columnDefs: [
          { "width":"5%","targets":0 }
          { "width":"25%","targets":1 }
          { "width":"10%","targets":2 }
        ]
      )

  $(document).ready(ready)
  
