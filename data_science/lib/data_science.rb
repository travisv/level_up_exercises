class DataScienceParser
  require 'json'
  attr_reader :file, :data

  def initialize(f)
    @file = File.read(f)
  end

  def to_json
    JSON.parse(file)
  end
end

class DataScience < Array
  require 'abanalyzer'
  attr_reader :data
  def initialize(data)
    @data = data
  end

  def sample_size(cohort)
    size = 0
    data.each do |sample|
      size += 1 if sample["cohort"] == cohort
    end
    size
  end

  def conversions(cohort)
    conversions = 0
    data.each do |sample|
      conversions += 1 if sample["cohort"] == cohort  && sample["result"] == 1
    end
    conversions
  end

  def chi_test(cohort_a, cohort_b)
    values = {}
    values[:agroup] = { :goals => self.conversions(cohort_a),
                        :visitors => self.sample_size(cohort_a) }
    values[:bgroup] = { :goals => self.conversions(cohort_b),
                        :visitors => self.sample_size(cohort_b) }
    ABAnalyzer::ABTest.new(values).chisquare_score
  end

  def confidence_interval(cohort)
    confidence = ABAnalyzer.confidence_interval(self.conversions(cohort),
                                                self.sample_size(cohort), 0.95)
    confidence.map! do |float|
      float.round(4)
    end
  end
end
