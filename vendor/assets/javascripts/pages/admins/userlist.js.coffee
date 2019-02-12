$ ->

  admin_table_api = undefined

  show_user_details = (data) ->
    console.log data
    window.location = "#{window.location}/#{data.id}"

  display_identity = (data,type,row) ->
    if data && data.provider
      data.provider
    else
      'internal'

  display_created_at = (data,type,row) ->
    I18n.l("time.formats.long",new Date(data))

  ready = ->
    ex = document.getElementById('admin_user_list')
    if !$.fn.DataTable.fnIsDataTable(ex)
      admin_table_api = $(ex).DataTable(
        createdRow: (row,data) ->
          $(row).on('click', (event) ->
            event.preventDefault()
            show_user_details(data)
          )

        ajax:
          url: $(ex).data("source")
          dataSrc: (json) ->
            json

        columns: [
          {
            data: 'id'
            "width":"5%"
          },
          {
            data: "email"
            "width":"25%"
          },
          {
            data: "dns_host_records.length"
            "width":"10%"
          },
          {
            data: "identity"
            render: display_identity
          },
          {
            data: "created_at"
            render: display_created_at
          }
        ]
      )

  $(document).ready(ready)
