module Ispremote

  module Soap  
    def remoteclient
        Savon.client :endpoint => Setting.ispconfig_url, 
                :ssl_verify_mode => :none, 
                :namespace => "https://web03.alwin-it.de:8080/remote/",
                :namespace_identifier => :ns1,
                :strip_namespaces => true, :convert_request_keys_to => :none, 
                :log_level => :debug, 
                :pretty_print_xml => true,
                :log => true,
                :filters => [:password],
                :soap_version => 2,
                :logger => Rails.logger
                
    end

    def operations(*operations)
      operations.each do |operation|
        define_class_operation(operation)
        define_instance_operation(operation)
      end
    end
    
    def define_class_operation(operation)
      class_operation_module.module_eval %{   
        def #{operation.to_s.snakecase}(locals = {})
          remoteclient.call #{operation.inspect}, locals
        end
      }
    end
    
    def define_instance_operation(operation)
      instance_operation_module.module_eval %{
        def #{operation.to_s.snakecase}(locals = {})
          self.class.#{operation.to_s.snakecase} locals
        end
      }
    end

    # Class methods.
    def class_operation_module
      @class_operation_module ||= Module.new {
        
      def client(globals = {})
        @client ||= remoteclient
      rescue InitializationError
        raise_initialization_error!
      end
      
      def global(option, *value)
        client.globals[option] = value
      end
      
      def raise_initialization_error!
      raise InitializationError,
        "Expected the model to be initialized with either a WSDL document or the SOAP endpoint and target namespace options.\n" \
        "Make sure to setup the model by calling the .client class method before calling the .global method.\n\n" \
        "client(wsdl: '/Users/me/project/service.wsdl')                              # to use a local WSDL document\n" \
        "client(wsdl: 'http://example.com?wsdl')                                     # to use a remote WSDL document\n" \
        "client(endpoint: 'http://example.com', namespace: 'http://v1.example.com')  # if you don't have a WSDL document"
      end
      
      }.tap { |mod| extend(mod) }
    end
    
    # Instance methods.
    def instance_operation_module
      @instance_operation_module ||= Module.new {
        
      def client
        self.class.remoteclient
      end
      
      }.tap { |mod| include(mod) }
    end
    
    def response_to_hash response
      isp_method = caller[0][/`.*'/][1..-2]
      resp = "#{isp_method}_response".to_sym
      rd = response.body[resp][:return]
    end
    
    def value_to_string v
      return v if v.is_a? String
      return "#{v}" if v.is_a? Integer
      ""
    end
    
    def flatten_hash r
      _h = r[:item]
      Hash[*_h.map {|v| [v[:key].to_sym,self.value_to_string(v[:value])]}.flatten]
    end
  end

end

