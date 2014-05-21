# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = "navigation_active"
  # Define the primary navigation

  navigation.items do |primary|
    primary.item :home,content_tag(:span, "Home"), root_path

    primary.item :dnszones,content_tag(:span, "DNS Zones"), client_dns_zones_path do |sub_nav|
      sub_nav.item :isp_dnszones,content_tag(:span, "Isp DNS Zones"),client_isp_dnszones_path
    end if current_user && current_user.instance_of?(ClientUser)

  end
end
