
class SettingsController < ApplicationController

  authorize_resource :class => Setting

  # GET /settings
  # GET /settings.json

  # GET /settings
  # Maps only to /settings/edit
  def index
    if html_request?
      edit
      render :action => 'edit'
    else
      settings = {
          mail_from: Setting.mail_from,
          ispconfig_url: Setting.ispconfig_url,
          remote_user: Setting.remote_user,
          remote_password: Setting.remote_password,
          max_records: Setting.max_records,
          default_ttl: Setting.default_ttl
      }
      render json: { settings: settings }, status: :ok
    end
  end

  # GET /settings/edit
  # handle a simple formular containing the settings
  def edit
    if request.post? && params[:settings] && (params[:settings].is_a?(Hash) || json_request?)
      settings = if params[:settings].is_a?(Hash)
                   (params[:settings] || {}).dup.symbolize_keys
                 else
                   params[:settings]
                 end
      settings.each do |name, value|
        # remove blank values in array settings
        value.delete_if {|v| v.blank? } if value.is_a?(Array)
        Setting[name.to_sym] = value
      end
      Setting.clear_cache
      if html_request?
        redirect_to :action => 'index'
      else
        render json: 'OK', status: :ok
      end
    else
      if json_request?
        render json: "Wrong parameter", status: :bad_request and return
      else
        @options = {}
      end
    end

  end

end
