# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = "navigation_active"
  
  # Define the primary navigation
  navigation.items do |primary|
    
    root_url = root_path if current_user.nil? || current_user.instance_of?(User)
    root_url = client_root_path if current_user.instance_of?(ClientUser)

    primary.item :home,content_tag(:span, "Home"), root_url do |sub_nav|
      sub_nav.item :user_login, content_tag(:span, "Login or register"),user_login_path unless current_user
      sub_nav.item :user_login, content_tag(:span, "Logout"),user_logout_path if current_user
    end

    if current_user && current_user.instance_of?(ClientUser)
      primary.item :dns, content_tag(:span, "DNS"), client_root_path do |sub_nav|
        sub_nav.item :dnszones,content_tag(:span, "DNS Zones"), client_dns_zones_path 
        sub_nav.item :isp_dnszones,content_tag(:span, "ISPConfig DNS Zones"),client_isp_dnszones_path
        sub_nav.item :dnsrecords, content_tag(:span, "DNS Records"), dns_zone_records_path
      end
    end
    
    if current_user
      
    end

  end
end
