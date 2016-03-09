require 'minitest/autorun'

describe "sudokuru_unit_log" do

  def capture_stdout(&block)
    original_stdout = $stdout
    $stdout = fake = StringIO.new
    begin
      yield
    rescue SystemExit => e
    ensure
      $stdout = original_stdout
    end
    fake.string
  end

  # def setup
  # end

  # def teardown
  # end

  # def initialize
  # end

  def squelch_warnings
    @warn_level = $VERBOSE
    $VERBOSE = nil
  end

  def unsquelch_warnings
    $VERBOSE = @warn_level
  end


  # LOGGING

  it "should not print debug logging when the DEBUG env var is not activated" do
    squelch_warnings
    output = capture_stdout {
      ENV['DEBUG'] = nil;
      load "././app/config.rb";
      load "././app/log.rb";
      Log.debug("Doot Doot");
    }
    unsquelch_warnings
    output.wont_include "Doot Doot"
  end

  it "should print debug logging when the DEBUG env var is activated" do
    squelch_warnings
    output = capture_stdout {
      ENV['DEBUG'] = "yes";
      load "././app/config.rb";
      load "././app/log.rb";
      Log.debug("Doot Doot");
    }
    unsquelch_warnings
    output.must_include "Doot Doot"
  end

  it "should print info logging" do
    squelch_warnings
    output = capture_stdout {
      load "././app/log.rb";
      Log.info("Generic (useful) information about system operation.");
    }
    unsquelch_warnings
    output.must_include "Generic (useful) information about system operation."
  end

end
