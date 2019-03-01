module Devise
  class UserFailureApp < Devise::FailureApp

    delegate :cookies, :session, to: :request

    def redirect
      errorinfo = i18n_message(:failed)

      if session.key?(:oauth)
        session[:oauth_error] = errorinfo
        redirect_to session['user_return_to']
      else
        super
      end

    end
  end
end