Citrus.eval( File.read(File.expand_path('../../benefits.citrus', __FILE__)) )

describe Benefits do
  subject { Benefits }

  describe :cost_share do
    [
      'In-Network: $0',
      'In-Network: Unlimited',
      'In-Network: 90%',
      'In-Network: Included in Medical',
      'Out-of-Network: $0',
      'In-Network: $50 before deductible, $0 after deductible',

      'In-Network: $50 then 50%',
      'In-Network: $50 then 50% after deductible',
      'In-Network: $120 first 5 visit(s) then $0',
    ].each do |str|
      it { should parse(str, as: :cost_share) }
    end
  end

  describe :limited do
    [
      '$500',
      '25%',
      '$120 first 5 visit(s)',
      '$50 before deductible',
      '$50 after deductible',
      '$50 before deductible then $0 after deductible',
      '$50 then $0 after deductible',
      '$50 then 1 exam per year',
      '$120 first 5 visit(s) then 10% per visit',
      '$100 per day first 5 day(s) then $0 per day',
      '$500 per visit before deductible then $10 per visit',
      '$500 per visit before deductible then $10 per visit after deductible',
    ].each do |str|
      it { should parse(str, as: :limited) }
    end
  end

  describe :tier_name do
    [
      'In-Network',
      'In-Network-Tier-2',
      'Out-of-Network',
    ].each do |(str, output)|
      it { should parse(str, as: :tier_name) }
    end
  end

  describe :coverage do
    [
      '$0',
      '50%',
      '$125 first 5 visit(s)',
      '$500 per exam',
      '$500 per exam first 5 exam(s)',
      '1 exam per year',
      '$500 per exam first 5 exam(s)',
    ].each do |str|
      it { should parse(str, as: :coverage) }
    end
  end

  describe :included do
    it { should parse('Included in Medical', as: :included) }
  end

  describe :discrete_treatment_unit do
    [
      'day',
      'days',
      'day(s)',
      'Day(s)',
      'items',
      'Items',
      'visits',
      'Visits',
      'exams',
      'Exams',
      'treatments',
      'Treatments',
    ].each do |str|
      it { should parse(str, as: :discrete_treatment_unit) }
    end
  end

  describe :then do
    [
      ', ',
      ' then ',
      ', then ',
    ].each do |str|
      it { should parse(str, as: :then) }
    end

    [
      ',',
      'then ',
      ', then',
      ' ,',
      ' , ',
      ', then'
    ].each do |str|
      it { should_not parse(str, as: :then) }
    end
  end

  describe :coverage_window do
    [
      'Year',
      'Benefit Period',
      'Day'
    ].each do |str|
      it { should parse(str, as: :coverage_window) }
    end
  end

  describe :dollar do
    {
      '$500.00' => 500.0,
      '$499.00' => 499.00,
      '$3'      => 3.0,
      '$0.65'   => 0.65,
      '$0.003'  => 0.003,
      '$1.003'  => 1.003,
    }.each do |(str, output)|
      it { should parse(str, as: :dollar).into(output) }
    end

    it { should_not parse('10.00', as: :dollar) }
    it { should_not parse('1.00', as: :dollar) }
    it { should_not parse('1', as: :dollar) }
    it { should_not parse('&5.00', as: :dollar) }
  end

  describe :percentage do
    {
      '50%'    => 0.5,
      '150%'   => 1.5,
      '7.5%'   => 0.075,
      '0.302%' => 0.00302,
    }.each do |(str, output)|
      it { should parse(str, as: :percentage).into(output) }
    end

    it { should_not parse('10', as: :percentage) }
    it { should_not parse('10.0', as: :percentage) }
    it { should_not parse('$10', as: :percentage) }
    it { should_not parse('15%', as: :percentage).into(0.14) }
  end

  describe :not_applicable do
    [
      'N/A',
      'Not Applicable',
      'NA'
    ].each do |str|
      it { should parse(str, as: :not_applicable).into('N/A') }
    end

    it { should_not parse('Applicable') }
  end
end
