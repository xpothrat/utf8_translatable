module Utf8Translatable
  require 'utf8_translatable/base'

  # include the extension 
  ActiveRecord::Base.send(:include, Utf8Translatable::Base)
end
