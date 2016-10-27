# encoding: utf-8
#
module Applogger
  
  @@methods = %w[debug info warn error fatal]
  
  @@methods.each do |name|
    src = <<-END_SRC
    # logging method
    def #{name}(message,logger=nil)
      if logger == nil
        if (defined? @logger)
          @logger.#{name} message
        else
          Logging.logger.root.#{name} message
        end
      else
        Logging.logger[logger].#{name} message
      end
    end
    END_SRC
    class_eval src, __FILE__, __LINE__
  end

  def getlogger(loggername);Logging.logger[loggername] end

end

