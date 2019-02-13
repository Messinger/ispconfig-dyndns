require 'logging/applogger'

class ApplicationDecorator < Draper::Decorator

  def logger
    @logger ||= logger
  end

end
