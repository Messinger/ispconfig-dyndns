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
    start_wait()
    $.ajax {
      url: url
      type: "DELETE"
      data: undefined
      success: (data,status,xhr) ->
        stop_wait()
        clean_tool_tips()
        table.row(row).remove().draw()
        activate_tool_tips()
      error: (req,msg,obj) ->
        stop_wait()
        console.log(req)
    }
    
  ask_delete_record = (event,element) ->
    event.preventDefault()
    yesno = yesnoDialog("Delete","Delete this record?",delete_record,element)

  show_new_record = (formcontent) ->

    if formcontent != undefined
      $('#recordformbody').html(formcontent)
    else
      $('form#new_dns_host_record').clearForm(true)

    $('#recordformdialog').modal()

  save_new_record = () ->

    f = $('form#new_dns_host_record')
    res = f.stringifyFormJSON()
    method = f.attr('method')

    $.ajax {
      url:  f.attr('action')
      type: method
      data: res
      contentType: "application/json; charset=utf-8"
      dataType: "json"
      success: (data, status, xhr)->
        turl = '<a href="' + xhr.getResponseHeader('Location') + '">' + data["name"] + "." + data["dns_zone"]["name"] + '</a>'
        tapi = $('#dnszone_records').DataTable()
        tapi.row.add(
          [
            turl
            data["dns_host_ip_a_record"]["address"]
            data["dns_host_ip_aaaa_record"]["address"]
            data["api_key"]["access_token"]
            get_delete_tag(data["id"], xhr.getResponseHeader('Location'))
          ]
        ).draw()
        make_delete_buttons()
        $('#recordformdialog').modal('hide')
      error: (data, stat, xhr) ->
        for sub,val of data.responseJSON
          for key,text of val
            ele = $('#' + sub + "_" + key)
            unless ele.length == 0
              ele.alertbox().print_error(text[0], 10)
    }

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

    $('#save_new_record').click (event) ->
      save_new_record()

    $(".addrecordbutton")
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
