require 'active_record'
require 'active_support/all'

require 'nulldb_rspec'
# include NullDB::RSpec::NullifiedDatabase
ActiveRecord::Base.establish_connection :adapter => :nulldb

require 'utf8_translatable'
require 'utf8_translatable/spec_support'