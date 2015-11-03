# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = nil

  a_opts = {:class => "dropdown-toggle","data-toggle" => "dropdown", "role"=>"button","aria-expanded" => 'false'}
  html_opts = {class: 'dropdown'}

  # Define the primary navigation
  navigation.items do |primary|
    
    root_url = root_path if current_account.nil? || current_user
    root_url = client_root_path if current_client_user
    root_url = admin_root_path if current_admin
    #opts = {:class => "dropdown", :link => a_opts }
    opts = {html: html_opts, link_html: a_opts}


    primary.item :home, content_tag(:span, "Home"),root_url

    if current_client_user || current_user
      primary.item :dns, content_tag(:span, "DNS")+content_tag(:span,"",:class => 'caret'), '#',opts do |sub_nav|
        if current_client_user
          sub_nav.item :dnszones,content_tag(:span, "DNS Zones"), client_dns_zones_path 
          sub_nav.item :isp_dnszones,content_tag(:span, "ISPConfig DNS Zones"),client_isp_dnszones_path
        end
        sub_nav.item :dnsrecords, content_tag(:span, "DNS Records"), dns_host_records_path
        sub_nav.dom_attributes = {:class => 'dropdown-menu', :role => 'menu'}
      end
    end
    

    if current_user
      primary.item :user_data, content_tag(:span,"Account")+content_tag(:span,"", :class => 'caret'), "#", opts  do |user_nav|
        user_nav.item :user_edit, content_tag(:span,"Edit information"),edit_user_registration_path
        user_nav.dom_attributes = {:class => 'dropdown-menu', :role => 'menu'}
      end
    end

    if current_admin
      primary.item :users, content_tag(:span,"User management")+content_tag(:span,"",:class => 'caret'), '#', opts do |sub_nav|
        sub_nav.item :userlist, content_tag(:span, "Known users"), admins_users_path
        sub_nav.dom_attributes = {:class => 'dropdown-menu', :role => 'menu'}
      end
      primary.item :app_settings, content_tag(:span, I18n.t('settings.global.head')),settings_path
      primary.item :admin_data, content_tag(:span, "Account"), admin_edit_path
    end

    if current_account
      primary.item :user_logout, content_tag(:span, "Logout"), send("destroy_#{current_account.class.name.underscore}_session_path"), :method => :delete
    end

    primary.item :user_login, content_tag(:span, "Login or register"),user_session_path unless current_account
    primary.dom_attributes = {class: 'nav navbar-nav'}

  end
end
