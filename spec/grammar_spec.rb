require 'citrus'
require_relative 'support/parse_citrus'

Citrus.eval( File.read(File.expand_path('../../benefits.citrus', __FILE__)) )

describe Benefits do
  subject { Benefits }

  describe :tier_name do
    {
      'In-Network:'       => 'In Network',
      'In-Network'        => 'In Network',
      'In-Network: '      => 'In Network',
      'In-Network-Tier-2' => 'In Network Tier 2',
      'Out-of-Network'    => 'Out of Network',
    }.each do |(str, output)|
      it { should parse(str, as: :tier_name).into(output) }
    end
  end

  describe :specific_treatments do
    [
      'first 1 day',
      'first 2 days',
      'first 48 visits',
      'first 7 items',
      'first 4 item(s)',
    ].each do |str|
      it { should parse(str, as: :specific_treatments) }
    end

    it { should_not parse('last 1 day', as: :specific_treatments) }
    it { should_not parse('last 1 day(s)', as: :specific_treatments) }
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
