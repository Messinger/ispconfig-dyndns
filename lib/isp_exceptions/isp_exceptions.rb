
# Module defining some exceptions which may rendered to html status
#
# Base for all exceptions is class RequestException
#
# for now following exceptions are implemented:
# * IspExceptions::BadRequest
# * IspExceptions::NotFound
# * IspExceptions::NotAuthenticated
# * IspExceptions::ForbiddenRequest
# * IspExceptions::NotAcceptable
# * IspExceptions::RequestTimedout
# * IspExceptions::UnsupportedMediatype
module IspExceptions

  # Base class for generating html exceptions
  class RequestException < StandardError

    # Initializes the exception
    # This should only called from child class initializers
    #
    # == Args
    # [default] the default message if no one is given by caller
    # [message] a message which may replace the default one
    # [code] the rails HTML status code assigned to this exception like :bad_request etc.
    #
    # == Examples
    #   raise BadRequest.new("The parameter #{p} is absolutly wrong")
    #   raise BadRequest
    def initialize(default="ok",message=nil,code)
      if (message == nil)
        @errormsg = default
      else
        @errormsg = message
      end
      @errorcode = code
    end

    # Returns the assigned html status code
    def code
      @errorcode
    end

    # Returns the assigned html status message
    def message
      @errormsg
    end

  end

  # Mark that the current request isn't known or not correct
  #
  # == HTTP status codes
  # <tt>400</tt>
  class BadRequest < RequestException

    # Initialize the Exception
    #
    # == Args
    # [message] A message which replaces the default message
    def initialize(message = nil)
      super 'The parameter for this request or the request is unknown or incorrect!',message,:bad_request
    end

  end

  # Mark that the current request is not authorized
  #
  # == HTTP status codes
  # <tt>401</tt>
  class NotAuthenticated < RequestException
    # Initialize the Exception
    #
    # * *Args*
    #   [message] A message which replaces the default message
    def initialize(message = nil)
      super 'Client is not authorized',message,:unauthorized
    end
  end

  # Mark that the current request is forbidden
  #
  # == HTTP status codes
  # <tt>403</tt>
  class ForbiddenRequest < RequestException
    # Initialize the Exception
    #
    # * *Args*
    #   [message] A message which replaces the default message
    def initialize(message = nil)
      super 'Request is forbidden',message,:forbidden
    end
  end

  # Mark that the current request couldn't find data
  #
  # == HTTP status codes
  # <tt>404</tt>
  class NotFound < RequestException
    # Initialize the Exception
    #
    # * *Args*
    #   [message] A message which replaces the default message
    def initialize(message = nil)
      super 'Value  not found',message,:not_found
    end
  end

  # Mark that the current request is not acceptable
  #
  # == HTTP status codes
  # <tt>406</tt>
  class NotAcceptable < RequestException
    # Initialize the Exception
    #
    # * *Args*
    #   [message] A message which replaces the default message
    def initialize(message = nil)
      super 'Request is not acceptable',message,:not_acceptable
    end
  end

  # Mark that the current request timed out
  #
  # == HTTP status codes
  # <tt>408</tt>
  class RequestTimedout < RequestException
    # Initialize the Exception
    #
    # * *Args*
    #   [message] A message which replaces the default message
    def initialize(message = nil)
      super 'The request timed out',message,:request_timeout
    end
  end

  # Request asks for unsupported Media
  #
  # == HTTP status codes
  # <tt>415</tt>
  class UnsupportedMediatype < RequestException
    # Initialize the Exception
    #
    # * *Args*
    #   [message] A message which replaces the default message
    def initialize(message = nil)
      super 'Unsupported media type',message,:unsupported_media_type
    end
  end

  class ServerError < RequestException
    # Initialize the Exception
    #
    # * *Args*
    #   [message] A message which replaces the default message
    def initialize(message = nil)
      super 'Server error',message,:internal_server_error
    end
  end

  # Mark that the current request is forbidden due Security problems
  #
  # == HTTP status codes
  # <tt>403</tt>
  class SecurityException < ForbiddenRequest
    # Initialize the Exception
    #
    # * *Args*
    #   [whattodo] Info what to do next
    #   [reason] The reason for this exception
    #   [message] The error message which replaces the default message
    def initialize(whattodo,reason,message = nil)
        super message
        @whattodo = whattodo
        @reason = reason
    end

    # Returns the assigned reason text
    def reason
      @reason
    end

    # Returns the assigned whattodo text
    def whattodo
      @whattodo
    end

  end
  
  # Mark a forced termination of a backend soap connection
  #
  class SoapConnectionTerminatedException < Exception
    # Initialize the Exception
    #
    # * *Args*
    #   [message] The error message which replaces the default message
    def initialize(message = nil)
        super message
    end
  end

end
