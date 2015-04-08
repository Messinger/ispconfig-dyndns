# Helper functions for generating
# settings edit page
module SettingsHelper

  def bootstrap_input(setting,options={})
    ftype = options.delete(:type)
    if ftype.blank?
      ftype = :text_field
    end
    ftype = "#{ftype}_tag".to_sym
    _label = options.delete(:label)
    if _label.blank?
      _label = setting
    end
    v = Setting.send(setting)
    n = "settings[#{setting}]"
    _class = options.delete(:class)
    _class = '' if _class.nil?
    _class += ' form-control'
    options[:class] = _class
    inp = send(ftype,n,v,options)
    inp_div = content_tag(:div,inp,:class => 'col-sm-6')
    ltag = label_tag(n,_label,:class => 'col-sm-4 control-label')
    content_tag(:div,ltag+inp_div,:class => 'form-group')
  end

end
