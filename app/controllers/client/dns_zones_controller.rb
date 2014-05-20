class Client::DnsZonesController < ApplicationController
  authorize_resource :class => DnsZone
  
  def index
    Rails.logger.info "Dnszone index"
  end

  def add_dnszone
  end

end
