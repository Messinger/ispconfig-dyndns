export user_logout = {
  name: 'user_logout'

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
}
