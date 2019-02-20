class User::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)
        session['user_return_to'] = close_sign_window_path if !!cookies['OAUTH-JSON-LOGIN']

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          session["devise.#{provider}_data"] = request.env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    }
  end

  # def github
  #    provider = 'github'
  #    @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)
  #
  #    if @user.persisted?
  #      sign_in_and_redirect @user, event: :authentication
  #      set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
  #    else
  #      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
  #      redirect_to new_user_registration_url
  #    end
  # end

  if PRIVATE_DATA['omni_auths']
    PRIVATE_DATA['omni_auths'].each do |provider|
      provides_callback_for provider.to_sym unless self.method_defined?(provider.to_sym)
    end
  end

  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      finish_signup_path(resource)
    end
  end

end
