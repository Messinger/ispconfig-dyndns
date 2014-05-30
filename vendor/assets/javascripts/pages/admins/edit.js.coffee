$ ->
  
  $(document).ready () ->
    $('#submit_admin_form').click (event) ->
      event.preventDefault()
      f = $('form.edit_admin')[0]
      f.submit()