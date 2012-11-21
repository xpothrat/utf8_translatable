module Utf8Translatable
  require_relative './utf8_translatable/base'

  # include the extension 
  ActiveRecord::Base.send(:include, Utf8Translatable::Base)
end
