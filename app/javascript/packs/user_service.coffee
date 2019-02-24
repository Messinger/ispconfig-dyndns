real_user_fetch = () ->
  response = await window.vueapp.axios.get('/users/fetch_user')
  console.log "Response: ",response

  response = await response
  console.log "Response: ",response

  if !!response && !!response.data
    response.data.account
  else
    null


export user_service = {
  name: 'user_service'

  user_logout: () ->
    if !!window.Constants.current_user
      usertype = window.Constants.current_user.type
      logouturl = switch usertype
        when 'ClientUser' then '/clients/logout'
        when 'User' then '/users/sign_out'
        when 'Admin' then '/admins/sign_out'
        else nil
      if !!logouturl
        window.vueapp.axios.delete(logouturl).then( (response) ->
          window.Constants.current_user = null
          window.vueapp.$root.$login_changed()
        ).catch(
          (error) ->
            window.Constants.current_user = null
            window.vueapp.$root.$login_changed()
        )

  retrieve_current_user: () ->
    user = await real_user_fetch()
    console.log "Got user: ",user
    user

  update_current_user: () ->
    user = await real_user_fetch()
    console.log "Got user for constants : ",user
    window.Constants.current_user = user
    window.Constants.current_user

  current_user: () ->
    window.Constants.current_user
}
