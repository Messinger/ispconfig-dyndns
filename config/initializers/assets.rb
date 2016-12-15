
js_prefix    = 'vendor/assets/javascripts/'
style_prefix = 'vendor/assets/stylesheets/'

javascripts = Dir["#{js_prefix}**/*.js"].map      { |x| x.gsub(js_prefix,    '') }
coffeescripts = Dir["#{js_prefix}**/*.coffee"].map      { |x| x.gsub(js_prefix,    '') }
css         = Dir["#{style_prefix}**/*.css"].map  { |x| x.gsub(style_prefix, '') }
scss        = Dir["#{style_prefix}**/*.scss"].map { |x| x.gsub(style_prefix, '') }

Rails.application.config.assets.precompile << coffeescripts << javascripts << css << scss
