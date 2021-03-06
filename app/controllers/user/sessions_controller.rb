class User::SessionsController < Devise::SessionsController
  respond_to :json, :html

  def create
    super do |resource|
      if request.format.json?
        resource.authentication_token = AuthenticationToken.new
        set_csrf_cookie
        render :json => {:success=>true, :current_user => resource.login_json, account: current_account.as_json.merge({'type':current_account.class.name})}, :status => :ok and return
      end
    end
  end

  def new
    super
  end

  def omniauth_providers
    session['user_return_to'] = close_sign_window_path
    providers = []
    if devise_mapping.omniauthable?
      resource_class.omniauth_providers.each do |provider|
        providers << {
            icon: auth_provider_to_cssname(provider),
            path: omniauth_authorize_path(resource_name, provider),
            name: provider
        }
      end
    end

    render json: providers.as_json, status: :ok
  end

  def fetch_user
    if current_account.nil?
      render json: {errormessage: session[:oauth_error]}, status: :ok
      session[:oauth_error] = nil
    else
      if current_user
        includes = [:unconfirmed_email]
      else
        includes = []
      end
      render json: {account: current_account.as_json(include: includes).merge({'type':current_account.class.name})}, status: :ok
    end
  end

  def close_window
    render 'shared/close_window', status: :ok
  end

  def destroy
    super do |resource|
      set_csrf_cookie
    end
  end

  private

  def auth_provider_to_cssname provider
    case provider
    when :google_oauth2
      "google"
    when :github
      "github-face"
    else
      provider
    end
  end

end
