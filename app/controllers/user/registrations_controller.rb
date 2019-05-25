class User::RegistrationsController < Devise::RegistrationsController

  clear_respond_to
  respond_to :json, :html

  def update
    error_request :bad_request unless params.key?(:user)
    user = User.accessible_by(current_ability).find params[:user][:id]

    error_request :not_found if user.nil?



#    is_external = !user.identity.nil?

#    if is_external
#      flash[:notice]="You can not edit your data"
#      respond_to do |format|
#        format.json {
#          render json: {:status => 'not possible'}, status: :ok
#        }
#        format.html {
#          redirect_to root_path
#        }
#      end and return
#    end
    super
  end

  def edit
    error_request :bad_request if current_user.nil?

    if json_request?
      render(json: { user: current_user.as_json(include: :identity )}, status: :ok) and return
    else
      super
    end
  end

  def destroy
    if current_user.nil?
      error_request :bad_request and return
    else
      user = current_user
      error_request :not_found if user.nil?

      user.dns_host_records.each do |record|
        rd = DnsHostRecordDecorator.new record
        rd.delete_remote
      end

      super
    end
  end

  protected

  def update_resource(resource, params)
    if params.key?(:current_password)
      resource.update_with_password(params)
    else
      resource.update(params)
    end
  end

end
