require '../../spec_helper'

require 'nulldb_rspec'
describe Utf8Translatable::Base do
  include NullDB::RSpec::NullifiedDatabase
  before do
    ActiveRecord::Base.establish_connection :adapter => :nulldb
    ActiveRecord::Migration.create_table(:translatables) do |t|
        t.string :col_en
        t.string :col_fr
    end
    class Translatable < ActiveRecord::Base
      ensures_translated_and_utf8
    end
  end
  it "should set 'enabled' models to is_utf8_translatable? = true" do
    Translatable.is_utf8_translatable?.should eql true
  end
  it "should provide models with universal getters for their translated columns" do
    instance = Translatable.new(:col_en => "en", :col_fr => "fr")
    I18n.available_locales.each do |l|
      I18n.locale = l
      instance._col.should eql instance.send("col_#{l}")
    end
  end
end

shared_examples "utf8_translatable" do
  it { described_class.is_utf8_translatable?.should eql true }
end