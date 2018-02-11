require_relative '../utils'

RSpec.describe Utils do
  describe "days_for_slice" do
    it "before slice returns 0" do
      expect(Utils::days_for_slice(2,4,10)).to eq(0)
    end
    it "after slice returns slice size" do
      expect(Utils::days_for_slice(11,4,10)).to eq(6)
    end
    it "inside slice returns proper result" do
      expect(Utils::days_for_slice(3,1,4)).to eq(2)
    end
  end
end