module DeviseHelper
  def error_messages! ob
    return '' if ob.errors.empty?

    messages = ob.errors.full_messages.map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-danger alert-block"> <button type="button"
    class="close" data-dismiss="alert">&times;</button>
      #{messages}
      </div>
      HTML

      html.html_safe
  end

  def devise_error_messages!
    error_messages! resource
  end

end
