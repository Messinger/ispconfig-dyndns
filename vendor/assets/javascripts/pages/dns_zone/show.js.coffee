$ ->
    
  show_new_record = (formcontent) ->
    base = '<div id="formcontent" title="Create new record"></div>'
    
    $('body').prepend(base)
    $("#formcontent").html(formcontent)
    $("#formcontent").dialog ({
            autopen: false
            modal: true
            width: 350
            buttons: {
              Cancel: () ->
                $(this).dialog("close")
                $(this).remove()    
            }
        })
    
  add_new_record = (event,element) ->
    console.log "Adding a new record for zone "+dnszone_id+" from "+newrecordurl;
    $.ajax {
        url: newrecordurl
        type: "GET"
        data: undefined
        success: (data,status,xhr) ->
            show_new_record(data)
        error: (req,msg,ojb) ->
            console.log(req)        
        }
    

  ready = ->
    $(".addrecordbutton")
        .button()
        .click (event) ->
            add_new_record(event,this)
    
    ex = document.getElementById('dnszone_records')
    
    if !$.fn.DataTable.fnIsDataTable( ex )
        $('#dnszone_records').dataTable(
            "order": [[ 0, "asc" ]]
            "columnDefs": [
                { "width":"20%", "targets" :0 },
                { "width":"20%", "targets" :1 },
                { "orderable": false, "targets": 2 }
                ]
            )
  $(document).ready(ready)
