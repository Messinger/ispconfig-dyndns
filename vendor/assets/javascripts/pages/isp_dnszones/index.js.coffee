$ ->

  drop_dns_zone = (event,element) ->
    event.preventDefault()
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
  
  add_dns_zone = (event,element) ->
    event.preventDefault()
    nRow = $(element).parents('tr');
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
    $("a.add-dns-zone").not('.ui-button')
        .button({
            icons: {primary:"ui-icon-plusthick"}
            text: false
            })
        .click (event) ->
            add_dns_zone(event,this)

  make_drop_buttons = () ->
    $("a.drop-dns-zone").not('.ui-button')
        .button({
            icons:{primary:"ui-icon-trash"}
            text: false
            })
        .click (event) ->
            drop_dns_zone(event,this)
  

  update_dns_row = (row, data, addzone) ->
    curdata = row.data()
    clean_tool_tips()
  
    if addzone == false
        actiontext = '<a class="add-dns-zone" href="#" data-ispzoneid="'+data+'">Add local zone</a>';
        curdata[2] = actiontext
        curdata[1] = "&nbsp;"
        row.data(curdata)
        make_add_buttons()
        
    else
        actiontext = '<a class="drop-dns-zone" href="#" data-ispzoneid="'+data.isp_dnszone_id+'" data-dropurl="'+dns_zone_path+'/'+data.id+'">Drop this local zone</a>';
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
