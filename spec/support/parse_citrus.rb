def parse(string, options={})
  ParseCitrus.new(string, options)
end

class ParseCitrus
  def initialize(expected, options)
    @input_str = expected
    @root = options.fetch(:as, nil)
  end

  def into(expected_val)
    @expected_val = expected_val
    self
  end

  def description
    msg = ''
    msg += 'not ' if @negated
    msg += "parse #{@input_str.inspect}"
    msg += " into #{@expected_val.inspect}" if @expected_val
    msg
  end

  def diffable?
    !@negated && @exception.nil?
  end

  def expected
    "#{@expected_val}\n"
  end

  def actual
    @parsed.value
  end

  def matches?(actual)
    @parser_class = actual
    @negated = false

    unless @parser_class.include? Citrus::Grammar
      fail ArgumentError, "Must supply a Citrus::Grammar. Got #{@parser_class}."
    end

    begin
      @parsed = @parser_class.parse(@input_str, root: @root)
    rescue Citrus::ParseError => e
      @exception = e
      return false
    end

    return true unless @expected_val

    @expected_val == @parsed.value
  end

  def does_not_match?(actual)
    @negated = true
    @parser_class = actual

    begin
      @parsed = @parser_class.parse(@input_str, root: @root)

      return false unless @expected_val

      @expected_val != @parsed.value
    rescue Citrus::ParseError => e
      @exception = e
      return true
    end
  end

  def failure_message
    msg = "Expected #{@parser_class} to parse '#{@input_str}' as :#{@root || 'root'}"
    msg += " into #{@expected_val.inspect}" if @expected_val
    msg += ", but got Citrus::ParseError:\n #{@exception}" if @exception
    msg
  end

  def failure_message_when_negated
    if @expected_val
      "Expected #{@parser_class} to not parse '#{@input_str}' as :#{@root || 'root'} into #{@expected_val.inspect}."
    else
      "Expected #{@parser_class} to raise Citrus::ParseError parsing '#{@input_str}' as :#{@root || 'root'}, but nothing was raised."
    end
  end
end
