require 'active_record'
require 'active_support/all'

# translates translatable columns (ex: title_en / title_fr => _title)
# ensures db queries return utf8 safe strings (monkey patching linked to ruby encoding issues in 2010)
module Utf8Translatable::Base
  extend ActiveSupport::Concern

  # Defines Methods to extend ActiveRecord::Base
  module ClassMethods

    # default state
    def is_utf8_translatable?
      false
    end

    # Defines '_#{column_name}' prefixed methods for each column of the table
    # that returns the corresponding attribute value translated in the correct
    # locale and utf8 safe encoded
    # 
    # * *Warning*
    #   Documentation to be detailed
    # 
    # * *NB*:
    #   Is defined in lib/model_helpers/ut8_translatable.rb, 
    #   which is included in initializers/active_record_extensions.rb
    # 
    # * *Examples*
    #   1. Composer has columns firstname and lastname.
    #   Calling @composer._firstname will return the firstname ut8 encoded
    #   2. Work has columns title_en and title_fr
    #   Calling @work._title will return @work.title_#{I18n.locale} utf8 encoded  
    #
    def ensures_translated_and_utf8
      if ActiveRecord::Base.connection.table_exists? table_name
        columns.map{|c| {:name => c.name.to_s, :type => c.type.to_s}}.each do |col|
          col_type, col_name = col[:type].try(:to_s), col[:name].try(:to_s)

          if col_type == 'string' || col_type == 'text'
            if is_translatable_attr?(col_type, col_name)
              _attr = col_name.gsub("_#{I18n.default_locale}", '')

              define_method _universal_method(col_name) do
                if send("#{_attr}_#{I18n.locale}").nil? then nil else send("#{_attr}_#{I18n.locale}").force_encoding(Encoding::UTF_8) end
              end

            else
              # ensure encoded in utf-8
              _attr = col_name
              _utf8_method = "_#{col_name}".to_sym

              define_method _utf8_method do
                if send(_attr).nil? then nil else send(_attr).force_encoding(Encoding::UTF_8) end
              end

            end
          end
        end
      end

      define_singleton_method :is_utf8_translatable? do
        true
      end

    end

    # if a model calls a _name method (assuming the model is utf8_translatable)
    # then running the migrations (before the name_en and name_fr actually exist)
    # won't work until the columns name_en and name_fr have actually been created
    # the method_missing should prevent this
    #
    rescue ActiveRecord::NoMethodError => e
      raise_unless_utf8_translatable_method(e)

    def raise_unless_utf8_translatable_method(exception = nil)
      if message =~ /^undefined method `_(\w+)'/
        #translated_attr = "#{$1}_#{I18n.locale.to_s}"
        #respond_to?(translated_attr) ? send(translated_attr) : nil
        nil
      else
        raise exception
      end
    end

    private
    # Defines is the attribute corresponds to a translatable attributes
    #
    # To be a translatable attribute it must
    # * be of type 'string' or 'text'
    # * have a structure of type [attr_name]_[locale]
    # * end with a locale that is in available_locales
    # * correspond to the default locale (ensures universal method is built only once 
    #   /+ that when it is built it has a fallback)
    #
    def is_translatable_attr?(col_type, col_name)
      (col_type == 'string' || col_type == 'text') and col_name.split('_').last && I18n.available_locales.map(&:to_s).include?(col_name.split('_').last) && col_name.split('_').last.to_sym == I18n.default_locale
    end

    # Returns the universal method name for a translatable attr
    #
    # * *Example*
    #   if col[:name] == 'name_en'
    #   and is_translatable_attr?(col)
    #   _universal_method returns
    #   _name    
    #
    def _universal_method(col_name)
      # create universal translated attr
      "_#{col_name.gsub("_#{I18n.default_locale}", '').to_sym}"
    end
  end
end