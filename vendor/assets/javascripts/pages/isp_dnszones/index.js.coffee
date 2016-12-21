$ ->

  drop_dns_zone = (element) ->
    nRow = $(element).parents('tr')
    nRow = $('#ispdnszones').DataTable().row(nRow)
    url = $(element).data("dropurl")
    zoneid = $(element).data("ispzoneid")
    $.ajax {
        url: url
        type: "DELETE"
        contentType: "application/json; charset=utf-8"
        dataType: "json"
        data: undefined
        success: (data,status,xhr) ->
            update_dns_row nRow,zoneid,false
        error: (req,msg,ojb) ->
            console.log(req)
    }
  
  ask_drop_dns_zone = (event,element) ->
    event.preventDefault()
    yesno = yesnoDialog("Delete this assignment?","Deleting this zone assignment will delete all associated DNS Records to.<br>Are you sure?",drop_dns_zone,element)

  add_dns_zone = (event,element) ->
    event.preventDefault()
    nRow = $(element).parents('tr')
    nRow = $('#ispdnszones').DataTable().row(nRow)
    id = $(element).data("ispzoneid")
    if id == undefined
        return
    url = add_zone_path
    data = "{\"ispzone_id\": \""+id+"\"}"
    $.ajax {
        url: url
        type: 'POST'
        contentType: "application/json; charset=utf-8"
        dataType: "json"
        data: data
        success: (data,status,xhr) ->
            update_dns_row nRow,data,true
        error: (req,msg,ojb) ->
            console.log(req)
        }


  make_add_buttons = () ->
    $(".add-dns-zone")
        .click (event) ->
            add_dns_zone(event,this)

  make_drop_buttons = () ->
    $(".drop-dns-zone")
        .click (event) ->
            ask_drop_dns_zone(event,this)
  

  update_dns_row = (row, data, addzone) ->
    curdata = row.data()
    clean_tool_tips()
  
    if addzone == false
        actiontext = '<button type="button" class="add-dns-zone btn btn-circle btn-primary" data-ispzoneid="'+data+'"><i class="fa fa-plus"></i></button>'
        curdata[2] = actiontext
        curdata[1] = "&nbsp;"
        row.data(curdata)
        make_add_buttons()
        
    else
        actiontext = '<button type="button" class="drop-dns-zone btn btn-circle btn-danger" data-ispzoneid="'+data.isp_dnszone_id+
            '" data-dropurl="'+dns_zone_path+'/'+data.id+'"><i class="fa fa-trash"></i></button>'
        curdata[2] = actiontext
        curdata[1] = '<a href="'+dns_zone_path+'/'+data.id+'">'+data.name+'</a>'
        row.data(curdata)
        make_drop_buttons()

    activate_tool_tips()
    
  ready = ->
    ex = document.getElementById('ispdnszones')

    if !$.fn.DataTable.fnIsDataTable( ex )
        $('#ispdnszones').dataTable(
            "order": [[ 0, "asc" ]]
            "columnDefs": [
                { "orderable": false, "targets": 2 }
                ]
            )

    make_add_buttons()
    make_drop_buttons()
    
  $(document).ready(ready)
