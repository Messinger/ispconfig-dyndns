$ ->
    
  show_new_record = (formcontent) ->

    if formcontent != undefined
      base = '<div id="formcontent" title="Create new record"></div>'
      $('body').prepend(base)
      $("#formcontent").html(formcontent)
      $("#formcontent").dialog ({
        autopen: false
        modal: true
        width: 380
        buttons: {
          Save: () ->
            f = $('form#new_dns_zone_record')
            res = f.stringifyFormJSON()
            method = f.attr('method')
            console.log res+" via "+method+" to "+f.attr('action')
            $.ajax {
              url:f.attr('action')
              type: method
              data:res
              contentType: "application/json; charset=utf-8"
              dataType: "json"
              success: (data,status,xhr)->
                console.log(data)
                tapi = $('#dnszone_records').DataTable()
                tapi.row.add(
                  [
                    data["name"]
                    data["dns_zone_a_record"]["address"]
                    data["dns_zone_aaaa_record"]["address"]
                    data["api_key"]["access_token"]
                    ""
                  ]
                ).draw()
              error: (req,msg,obj) ->
                console.log(req)
            }
            $(this).dialog("close")
          Cancel: () ->
            $(this).dialog("close")
          }
        })
    else
      $('form#new_dns_zone_record').clearForm()
      $('#formcontent').dialog('open')
    
  add_new_record = (event,element) ->
    event.preventDefault()
    formdiff = $('#formcontent')

    if formdiff.length == 0
        $.ajax {
            url: newrecordurl
            type: "GET"
            data: undefined
            success: (data,status,xhr) ->
                show_new_record(data)
            error: (req,msg,ojb) ->
                console.log(req)
            }
    else
      show_new_record(undefined)
    

  delete_record = (element) ->
    url = $(element).data("url")
    row = $(element).parents("tr")
    console.log "Delete on "+url+" in "
    console.log row
    
  ask_delete_record = (event,element) ->
    event.preventDefault()
    yesno = yesnoDialog("Delete","Delete this record?",delete_record,element);
    
  ready = ->
    $(".addrecordbutton")
        .button()
        .click (event) ->
            add_new_record(event,this)
    
    $(".deleterecordbutton")
        .button()
        .click (event) ->
            ask_delete_record(event,this)

    ex = document.getElementById('dnszone_records')
    
    if !$.fn.DataTable.fnIsDataTable( ex )
        $('#dnszone_records').dataTable(
            "order": [[ 0, "asc" ]]
            "columnDefs": [
                { "width":"20%", "targets" :0 },
                { "width":"20%", "targets" :1 },
                { "width":"20%", "targets" :2 },
                { "orderable": false, "targets": 3 }
                { "orderable": false, "targets": 4 }
                ]
            )
  $(document).ready(ready)
