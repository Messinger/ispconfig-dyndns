$ ->
   
  make_delete_buttons = () ->
    $("a.deleterecordbutton").not('.ui-button')
      .button({
          icons: {
              primary: "ui-icon-trash"
                  }
          text: false
          })
      .click (event) ->
        ask_delete_record(event,this)
   
  get_delete_tag = (id,location) ->
    '<a class="deleterecordbutton" data-id="'+id+'" data-url="'+location+'" href="#" id="delete_record_'+id+'">Delete</a>'

  delete_record = (element) ->
    url = $(element).data("url")
    row = $(element).parents("tr")
    console.log "Delete on "+url+" in "
    console.log row
    table = $('#dnszone_records').DataTable()
    $.ajax {
      url: url
      type: "DELETE"
      data: undefined
      success: (data,status,xhr) ->
        clean_tool_tips()
        table.row(row).remove().draw()
        activate_tool_tips()
      error: (req,msg,obj) ->
        console.log(req)
    }
    
  ask_delete_record = (event,element) ->
    event.preventDefault()
    yesno = yesnoDialog("Delete","Delete this record?",delete_record,element)

  show_new_record = (formcontent) ->

    if formcontent != undefined
      base = '<div id="formcontent" title="Create new record"></div>'
      $('body').prepend(base)
      $("#formcontent").html(formcontent)
      $("#formcontent").dialog ({
        autopen: false
        modal: true
        width: 450
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
                tapi = $('#dnszone_records').DataTable()
                tapi.row.add(
                  [
                    data["name"]+"."+data["dns_zone"]["name"]
                    data["dns_zone_a_record"]["address"]
                    data["dns_zone_aaaa_record"]["address"]
                    data["api_key"]["access_token"]
                    get_delete_tag(data["id"],xhr.getResponseHeader('Location'))
                  ]
                ).draw()
                make_delete_buttons()
              error: (req,msg,obj) ->
                console.log(req)
            }
            $(this).dialog("close")
          Cancel: () ->
            $(this).dialog("close")
          }
        })
    else
      $('form#new_dns_zone_record').clearForm(true)
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


  ready = ->
    make_delete_buttons()

    $(".addrecordbutton")
        .button({
            icons: {
                primary: "ui-icon-plusthick"
                }
            text: false
            })
        .click (event) ->
            add_new_record(event,this)

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
