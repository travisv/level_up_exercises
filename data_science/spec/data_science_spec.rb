require 'data_science'
require 'abanalyzer'

RSpec.describe DataScience do
  before do
    file = DataScienceParser.new('test_data.json').to_json
    @data = DataScience.new(file)
  end

  it "should calculate the sample size" do
    expect(@data.sample_size("A")).to eq 120
    expect(@data.sample_size("B")).to eq 130
  end

  it "should calculate the conversions in each cohort" do
    expect(@data.conversions("A")).to eq 13
    expect(@data.conversions("B")).to eq 5
  end

  it "should calculate the chitest score" do
    expect(@data.chi_test("A", "B")).to eq true
  end

  it "should calculate the confidence_interval" do
    expect(@data.confidence_interval("A")).to eq [0.0527, 0.1639]
    expect(@data.confidence_interval("B")).to eq [0.0054, 0.0715]
  end
end
