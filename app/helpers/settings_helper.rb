# Helper functions for generating
# settings edit page
module SettingsHelper

  # generate a html selectbox
  #
  # * *Args*
  #   [setting] name of the setting
  #   [choices] choices for the selectbox
  #   [options] various options, if not listed below them will appended to html tag
  #
  # * *Options*
  #   [blank] insert a blank option at beginning of selectbox, if it is a symbol insert content of symbol
  #   [as_table] format output as table row if set
  def setting_select(setting,choices,options={})
    if blank_text = options.delete(:blank)
      choices = [[blank_text.is_a?(Symbol) ? l(blank_text):blank_text,'']]+choices
    end
    tbs = tableblocks(options.delete(:as_table))
    tbs['tpr'] + setting_label(setting, options).html_safe+tbs['tdd'] +
    select_tag("settings[#{setting}]",
             options_for_select(choices,Setting.send(setting).to_s),options).html_safe+ tbs['ten']
  end

  # generate a html label
  # * *Args*
  #   [setting] The setting for which the label should generated
  #   [options] various options, if not listed below them will appended to html tag
  # * *Options*
  #   [label] the label to print. If not set then a label depending on the name of setting is generated
  def setting_label(setting, options={})
    label = options.delete(:label)
    label != false ? content_tag("label", (label || "setting_#{setting}"),options).html_safe : ''
  end

  # generate a html input field named "settings[settingname]"
  # * *Args*
  #   [setting] The setting for which the input field is generated
  #   [options] various options, if not listed below them will appended to html tag
  # * *Options*
  #   [as_table] format output as table row if set
  def setting_text_field(setting, options={})
    tbs = tableblocks(options.delete(:as_table))
    tbs['tpr']+setting_label(setting, options).html_safe + tbs['tdd']+
      text_field_tag("settings[#{setting}]", Setting.send(setting), options).html_safe+tbs['ten']
  end
  
  def setting_password_field(setting,options={})
    tbs = tableblocks(options.delete(:as_table))
    tbs['tpr']+setting_label(setting, options).html_safe + tbs['tdd']+
      password_field_tag("settings[#{setting}]", '', options).html_safe+tbs['ten']
  end

  # generate a html textarea named "settings[settingname]"
  # * *Args*
  #   [setting] The setting for which the input field is generated
  #   [options] various options, if not listed below them will appended to html tag
  # * *Options*
  #   [as_table] format output as table row if set
  def setting_text_area(setting, options={})
    tbs = tableblocks(options.delete(:as_table))
    tbs['tpr']+setting_label(setting, options).html_safe + tbs['tdd'] +
      text_area_tag("settings[#{setting}]", Setting.send(setting), options).html_safe+tbs['ten']
  end

private
  # internal use only
  def tableblocks(as_table)
    tbs = {}

    if as_table
      tbs['tpr']="<tr><td>".html_safe
      tbs['tdd']="</td><td>".html_safe
      tbs['ten']="</td></tr>".html_safe
    else
      tbs['tpr']="".html_safe
      tbs['tdd']=" ".html_safe
      tbs['ten']="".html_safe
    end
    return tbs
  end

end
