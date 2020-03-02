
# Some of these controls are waivered by the file waivers/waivers.yaml

# control-01 is normal, should pass
control "control-01" do
  describe "the expected value" do
    it { should cmp "the expected value" }
  end
end

# control-02 is permanently waivered, should be skipped
control "control-02" do
  describe "the expected value" do
    it { should cmp "the expected value" }
  end
end
