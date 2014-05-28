class User::RegistrationsController < Devise::RegistrationsController

  def destroy
    
    user = User.find(current_user.id)

    recordid = user.id

    user.dns_zone_records.each do |record|
      rd = DnsZoneRecordDecorator.new record
      rd.delete_remote
    end
    
    user.destroy
    reset_session
    
    respond_to do |format|
      format.json {
        render json: {"deleted" => recordid}, status: :ok
      }
      format.html {
        redirect_to root_path
      }
    end

  end

end
