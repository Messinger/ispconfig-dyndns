module ApplicationHelper
  # generate a title tag for html
  # == ARGS
  # [page_title] extra title text
  # == Returns
  # New html title
  def full_title(page_title)
    return "#{page_title}".html_safe unless page_title.empty?
    'IspConfig Dyndns broker'
  end

  # Much like usual rails route helpers,
  # whether you realized it or not, you can pass
  # option :only_path => false to get a
  # full URL instead of a
  # relative path.
  def public_static_path(path, options = nil)
    root_path(options) + path
  end

  def auth_provider_to_cssname provider
    case provider
      when :google_oauth2
        "google-plus"
      else
        provider
    end
  end

  def records_list
    DnsHostRecordDecorator.decorate_collection(DnsHostRecord.accessible_by(current_ability))
  end
end
