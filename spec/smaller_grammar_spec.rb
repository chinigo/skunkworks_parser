Citrus.eval( File.read(File.expand_path('../../smaller.citrus', __FILE__)) )

describe Smaller do
  subject { Smaller }

  describe :tier do
    [
      'In-Network: $0',
      'Out-of-Network: $10000',
      'Out-of-Network: Unlimited',
      'Out-of-Network: 30%',
      'In-Network: $0 before deductible',
      'Out-of-Network: 30% after deductible',
      'Out-of-Network: $15 then 50%',
      'Out-of-Network: $15 before deductible then 50%',
      'Out-of-Network: $1500 before deductible then 50% after deductible',
      'Out-of-Network: $5000 per person',
      'Out-of-Network: $5000 per person then $10000 per group',
      'In-Network: $30 per Day',
      'In-Network: $375 per day after deductible then $0 after deductible',
      'In-Network: $50 per script',
      'In-Network: $50 per visit(s) after deductible',
      'In-Network: 1 exam(s) per year'
    ].each do |str|
      it { should parse(str, as: :tier) }
    end
  end

  describe :overall do
    [
      'In-Network-Tier-2: $75 / Out-of-Network: 50% after deductible',
      'In-Network: $0 / In-Network-Tier-2: $0 / Out-of-Network: 100% | limit: 120 day(s) per Benefit Period',
      'In-Network: $0 / In-Network-Tier-2: $0 / Out-of-Network: 60% after deductible | limit: 3 Item(s) per Year',
      'In-Network: $0 / In-Network-Tier-2: $40 after deductible / Out-of-Network: 100%',
      'In-Network: $0 after deductible / Out-of-Network: 100% | limit: 60 visit(s) per 12 month(s)'
    ].each do |str|
      it { should parse(str, as: :overall) }
    end
  end

  describe :limitation do
    [
      'limit: 1 exam per Year',
      'limit: 60 visit(s) per 12 month(s)',
      'limit: 60 day(s) per year',
      'limit: 60 Days per Benefit Period',
      'limit: 30 visit(s) per Lifetime',
      'limit: 1 Item(s) per Year',
      'limit: 180 day(s) per Period',
      'limit: 4 Treatment(s) per Year'
    ].each do |str|
      it { should parse(str, as: :limitation) }
    end
  end

  describe 'integration test' do
    fixtures = File.open(File.expand_path('../fixtures/reasonable_benefits.txt', __FILE__), 'r')

    fixtures.each_line do |line|
      it { should parse(line.chomp, as: :overall) }
    end
  end
end
