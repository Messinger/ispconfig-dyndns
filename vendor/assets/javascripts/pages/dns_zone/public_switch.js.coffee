$ ->
  $(document).ready () ->

    $('.dns_zone_public_box').change (event) ->
      box = $(this)
      makepublic = box.is(':checked')
      url = box.data("update_url")
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
          box.attr("checked",!makepublic)
        }
  
  
  