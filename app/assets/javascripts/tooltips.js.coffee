$ ->

  window.activate_tool_tips = () ->
    $(document).tooltip()


  window.clean_tool_tips = () ->
    $(document).tooltip("destroy")

