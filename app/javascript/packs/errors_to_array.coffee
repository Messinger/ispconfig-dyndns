# converts a rails JSON error hash to array of messages
export errors_to_array = {
  name: 'errors_to_array'

  is_object: (el) ->
    !!(el) && (el.constructor == Object)

  error_hash_to_array: (error_hash) ->
    unless this.is_object(error_hash)
      return [JSON.stringify(error_hash)]
    result = []

    for own key,values of error_hash
      console.log "checking key ",key," with values ", values
      for i in values
        result.push("#{key} #{i}")

    result
}
