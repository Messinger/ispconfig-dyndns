
# Application Wide Model
# Provides main functionality for models that are used in views 
class PresentationModel
  include ActiveModel::Serializers::JSON
  include ActiveModel::Serializers::Xml
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :id

  def set_id(id)
    @id = id
  end
  
  # copied from ActiveRecord
  def persisted?
    !(self.id.nil?)
  end
  
  # copied from ActiveRecord
  def new_record?
    !persisted?
  end
  
  # Single attribute validation method
  def self.valid_attribute?(attr, value)
    mock = self.new(attr => value)
    unless mock.valid?
      if mock.errors.has_key?(attr)
        return mock.errors[attr] 
      end
    end
    true
  end
  
  def self.attributes_for_fixnum
    { :key => { "xsi:type" => "xsd:string"}, :value => {"xsi:type" => "xsd:int" } }
  end

  singleton_class.send(:alias_method,:attributes_for_integer, :attributes_for_fixnum)
  singleton_class.send(:alias_method,:attributes_for_int, :attributes_for_fixnum)

  def self.attributes_for_string
    { :key => { "xsi:type" => "xsd:string"}, :value => {"xsi:type" => "xsd:string" } }
  end

  def self.valid_attribute_set?(attribute_set, instance)
    instance.errors.clear
    
    if instance.valid?
      return Array.new()
    end
    
    result_arr = Hash.new()
    attribute_set.each do | attribute |
      if instance.errors.has_key? attribute
        if instance.errors[attribute].is_a?(Array)
          errors = Array.new()
          instance.errors[attribute].each do | attribute_error |
            errors << attribute_error
          end
          result_arr[attribute] = errors
        else
          result_arr[attribute] = instance.errors[attribute]
        end
      end
    end
    instance.errors.clear
    return result_arr
  end
  
  # Generic initialization method to init Instances with every instance attribute
  def initialize(*h)
    if h.length == 1 && h.first.kind_of?(Hash)
      h.first.each do |k,v| 
        if !respond_to? "#{k}"
          self.class_eval("def #{k};@#{k};end")
          self.class_eval("def #{k}=(val);@#{k}=val;end")
        end
        send("#{k}=",v) 
      end
    end
  end
  
  
  # List of attributes, used by as_json
  alias :attributes :instance_values
  
  # List of attributes to exclude on serialization
  def self.active_model_attributes
    [
      :errors,
      :validation_context,
    ]
  end
  
  def gen_timestamp
    if self.respond_to? :serial
      current = self.serial
      if current.length < 10
        self.gen_timestamp
      else
        cd = current[0..7]
        if Time.now.strftime("%Y%m%d") == cd
          number = sprintf("%02d",current[8..-1].to_i+1)
          cd+number
        else
          self.class.gen_timestamp
        end
      end
    else
      self.class.gen_timestamp
    end
  end

  def self.gen_timestamp
    Time.now.strftime("%Y%m%d01")
  end

end
