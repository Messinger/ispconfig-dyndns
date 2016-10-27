$ ->

  docready = () ->
    $('#btn-send-confirmation-token').click (event) ->
      token = $('#confirmation_token').val()
      urlparam = $.param({confirmation_token: token})
      url = window.gettokenurl+"?"+urlparam
      window.location = url
      return
  $(document).ready (docready)
  return
