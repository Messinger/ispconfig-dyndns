$ ->

  admin_table_api = undefined

  show_user_details = (element) ->
    row = admin_table_api.row(element)
    console.log row.data()


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
        drawCallback: (oSettings) ->
          $('#admin_user_list > tbody').on('click','tr', (event) ->
            show_user_details(this)
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
