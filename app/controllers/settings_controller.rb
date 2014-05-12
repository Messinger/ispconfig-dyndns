
class SettingsController < ApplicationController

  # GET /settings
  # GET /settings.json

  # GET /settings
  # Maps only to /settings/edit
  def index
    edit
    render :action => 'edit'
  end

  # GET /settings/edit
  # handle a simple formular containing the settings
  def edit
    if request.post? && params[:settings] && params[:settings].is_a?(Hash)
      settings = (params[:settings] || {}).dup.symbolize_keys
      settings.each do |name, value|
        # remove blank values in array settings
        value.delete_if {|v| v.blank? } if value.is_a?(Array)
        Setting[name] = value
      end
      Setting.clear_cache
      redirect_to :action => 'index'
    else
      @options = {}
    end

  end

end
