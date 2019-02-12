class Admins::UsersController < ApplicationController
  authorize_resource :class => User

  respond_to :json, :html

  def index
    @users = User.accessible_by(current_ability)
    respond_to do |format|
      format.html {respond_with @users}
      format.json {
        respond_with @users.as_json(:include => [:dns_host_records,:identity]), :status => :ok
      }
    end
  end

  def show
    @user = User.accessible_by(current_ability).find params[:id]
    respond_to do |format|
      format.html
      format.json {
        respond_with @user.as_json(:include => [:dns_host_records,:identity])
      }
    end
  end

  def destroy
    user = User.accessible_by(current_ability).find params[:id]
    status = if user.nil?
               :not_found
             else
              records = DnsHostRecordDecorator.decorate_collection(user.dns_host_records)
              records.each do |record|
                record.delete_remote
              end
              user.destroy
              :ok
             end

    respond_to do |format|
      format.html {
        redirect_to admins_users_path
      }
      format.json {
         render json: {}, status: status
      }
    end

  end

end
