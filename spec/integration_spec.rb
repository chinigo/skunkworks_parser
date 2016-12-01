Citrus.eval( File.read(File.expand_path('../../benefits.citrus', __FILE__)) )

describe 'integration' do
  subject { Benefits }

  File.open(File.expand_path('../fixtures/reasonable_benefits.txt', __FILE__), 'r') do |f|
    i = 0
    f.each_line do |line|
      it { should parse(line.chomp.strip) }
      # break if (i+=1) == 2000
    end
  end
end
