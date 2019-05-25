
export ip_validator = {
  name: 'ip_validator'
  data: () ->
    ip6_regex: /^((?=.*::)(?!.*::.+::)(::)?([\dA-F]{1,4}:(:|\b)|){5}|([\dA-F]{1,4}:){6})((([\dA-F]{1,4}((?!\3)::|:\b|$))|(?!\2\3)){2}|(((2[0-4]|1\d|[1-9])?\d|25[0-5])\.?\b){4})$/i
    ip4_regex: /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/

  validate_ip4: (address) ->
    res = address.match(this.data().ip4_regex)
    !!res

  validate_ip6: (address) ->
    res = address.match(this.data().ip6_regex)
    !!res
}