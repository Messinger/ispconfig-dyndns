module ApplicationHelper
  # generate a title tag for html
  # == ARGS
  # [page_title] extra title text
  # == Returns
  # New html title
  def full_title page_title
    return "#{page_title}".html_safe unless page_title.empty?
    "IspConfig Dyndns broker"
  end
end
