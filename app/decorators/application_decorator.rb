require 'logging/applogger'

class ApplicationDecorator < Draper::Decorator

  def logger
    @logger ||= ::Logging::Logger["ApplicationDecorator::#{self.class.logger_name}"]
  end

end
