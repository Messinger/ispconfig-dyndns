# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = "navigation_active"
  
  # Define the primary navigation
  navigation.items do |primary|
    
    root_url = root_path if current_account.nil? || current_user
    root_url = client_root_path if current_client_user
    root_url = admin_root_path if current_admin

    primary.item :home,content_tag(:span, "Home"), root_url do |sub_nav|
      sub_nav.item :dns_records, content_tag(:span,"Dns Records"), dns_host_records_path if !current_account.nil? && current_account.instance_of?(User)
    end

    if current_client_user
      primary.item :dns, content_tag(:span, "DNS"), client_root_path do |sub_nav|
        sub_nav.item :dnszones,content_tag(:span, "DNS Zones"), client_dns_zones_path 
        sub_nav.item :isp_dnszones,content_tag(:span, "ISPConfig DNS Zones"),client_isp_dnszones_path
        sub_nav.item :dnsrecords, content_tag(:span, "DNS Records"), dns_host_records_path
      end
    end
    

    if current_user
      primary.item :user_data, content_tag(:span,"Account"), ""  do |user_nav|
        user_nav.item :user_edit, content_tag(:span,"Edit information"),edit_user_registration_path
      end
    end

    if current_admin
      primary.item :admin_data, content_tag(:span, "Account"), admin_edit_path
    end

    if current_account
      primary.item :user_logout, content_tag(:span, "Logout"), send("destroy_#{current_account.class.name.underscore}_session_path"), :method => :delete
    end

    if !current_account
      primary.item :user_login, content_tag(:span, "Login or register"),user_session_path unless current_account
    end

  end
end
