(($) ->
# convert a form into JSON object
# var res = f.serializeFormJSON();
  $.fn.serializeFormJSON = () ->
    matcher = ""
    res = {}
    a = this.serializeArray()
    $.each(a, () ->
      ar = this.name
      ar_split = ar.match(/(.*)\[(.*)\]/)
      
      o = res
      value = this.value
      if ar_split != null && ar_split.length == 3
        if !o[ar_split[1]]
          o[ar_split[1]] = {}
        o =  o[ar_split[1]]
        ar = ar_split[2]
      if o[ar]
        if !o[ar].push
          o[ar] = [o[ar]]
        o[ar].push(value || '')
      else
        o[ar] = value || ''
    )
    return res

# Convert a form into stringified json object
# this may used for ajax based calls
# var res = f.stringifyFormJSON()
  $.fn.stringifyFormJSON = () ->
    JSON.stringify(this.serializeFormJSON())

# reset a form
# if noselect == true, then ignore select boxes
  $.fn.clearForm = (noselect) ->
    this.each(() ->
      type = this.type
      tag = this.tagName.toLowerCase()
      if tag == 'form'
        return $(':input',this).clearForm(noselect)
      if type == 'text' || type == 'password' || tag == 'textarea'
        this.value = ''
      else if type == 'checkbox' || type == 'radio'
        this.checked = false
      else if tag == 'select' && !(noselect == true)
        this.selectedIndex = -1
    )
) jQuery
