$ ->

@activate_tool_tips = () ->
  $(document).tooltip()

@clean_tool_tips = () ->
  $(document).tooltip("destroy")
