require 'logging/applogger'

class ApplicationDecorator < Draper::Decorator

  def logger
    @logger ||= Rails.logger
  end

end
