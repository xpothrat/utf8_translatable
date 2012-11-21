shared_examples "utf8_translatable" do
  it { described_class.is_utf8_translatable?.should eql true }
end