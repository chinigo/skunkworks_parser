Citrus.eval( File.read(File.expand_path('../../benefits.citrus', __FILE__)) )

describe Benefits do
  subject { Benefits }

  describe :tier do
    [
      'In-Network: $0',
      'In-Network: unknown',
      'Out-of-Network: $10000',
      'Out-of-Network: Unlimited',
      'Out-of-Network: 30%',
      'Out-of-Network: NA',
      'Combined-Networks: $5000',
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
      'In-Network: 1 exam(s) per year',
      'Out-of-Network: 100% after $30 reimbursement',
      'Out-of-Network: $0 after $25 allowance',
      'Out-of-Network: 100% after $40 rebate',
      'Out-of-Network: 100% after $30',
      'In-Network-Tier-2: $0 first 3 visit(s) then 30% after deductible',
      'Out-of-Network: 50% after deductible up to $300 per day',
      'Out-of-Network: 50% after deductible up to 1 items per year',
      'Out-of-Network: 100% first 5 visits',
      'Out-of-Network: 25% penalty then 20% after deductible',
      'Out-of-Network: 50% after deductible 1 items per year'
    ].each do |str|
      it { should parse(str, as: :tier) }
    end
  end

  it { should parse('50% after deductible', as: :simple_coverage) }
  it { should parse('1 items per year', as: :simple_coverage) }

  describe :overall do
    [
      'In-Network-Tier-2: $75 / Out-of-Network: 50% after deductible',
      'In-Network: $0 / In-Network-Tier-2: $0 / Out-of-Network: 100% | limit: 120 day(s) per Benefit Period',
      'In-Network: $0 / In-Network-Tier-2: $0 / Out-of-Network: 60% after deductible | limit: 3 Item(s) per Year',
      'In-Network: $0 / In-Network-Tier-2: $40 after deductible / Out-of-Network: 100%',
      'In-Network: $0 after deductible / Out-of-Network: 100% | limit: 60 visit(s) per 12 month(s)',
      'In-Network: $0 / Out-of-Network: $5000 / Combined-Networks: $5000'
    ].each do |str|
      it { should parse(str, as: :overall) }
    end
  end

  describe :limitation do
    [
      'limit: 1 exam per Year',
      'limit: 1 per Year',
      'limit: 60 visit(s) per 12 month(s)',
      'limit: 60 day(s) per year',
      'limit: 60 Days per Benefit Period',
      'limit: 30 visit(s) per Lifetime',
      'limit: 1 Item(s) per Year',
      'limit: 180 day(s) per Period',
      'limit: 4 Treatment(s) per Year',
      'limit: $0 first 2 visit(s)',
      'limit: 1 exam(s) per calendar year(s)',
      'limit: $750 per child up to 5 years old',
      'limit: first 4 visit(s) copay applies',
      'limit: copay waived if admitted',
      'limit: 1 item(s) per 12 month(s) period',
      'limit: 6 consecutive month(s)',
      'limit: $1000 per Trip'
    ].each do |str|
      it { should parse(str, as: :limitation) }
    end
  end
end
