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
    
    $('.dns_zone_public_box').change (event) ->
      box = $(this)
      makepublic = box.is(':checked')
      url = box.data("update_url")
      console.log "Make public: "+makepublic
      map = {}
      map['dns_zone'] = { "id" : box.data('dns_zone_id'), 'is_public':makepublic }
      data = JSON.stringify(map)
      console.log data
      $.ajax {
        url : url
        type: "PUT"
        data: data
        contentType: "application/json; charset=utf-8"
        dataType: "json"
        success: (data,status,xhr) ->
          console.log (data)
        error: (req,msg,obj) ->
          console.log req
      }
      
      
  $(document).ready(ready)
