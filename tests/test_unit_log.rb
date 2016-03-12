require 'minitest/autorun'
require "matrix"

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

  def setup
    squelch_warnings
  end

  def teardown
    unsquelch_warnings
  end

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
    output = capture_stdout {
      ENV['DEBUG'] = nil;
      load "././app/config.rb";
      load "././app/log.rb";
      Log.debug("Doot Doot");
    }
    output.wont_include "Doot Doot"
  end

  it "should print debug logging when the DEBUG env var is activated" do
    output = capture_stdout {
      ENV['DEBUG'] = "yes";
      load "././app/config.rb";
      load "././app/log.rb";
      Log.debug("Doot Doot");
    }
    output.must_include "Doot Doot"
  end

  it "should print info logging" do
    output = capture_stdout {
      load "././app/log.rb";
      Log.info("Generic (useful) information about system operation.");
    }
    output.must_include "Generic (useful) information about system operation."
  end

  it "should print tab logging" do
    output = capture_stdout {
      load "././app/log.rb";
      Log.tab(Matrix.identity(2));
    }
    output.must_include "\n  10\n  01\n"
  end

  it "should print double_tab logging" do
    output = capture_stdout {
      load "././app/log.rb";
      Log.double_tab(Matrix.identity(3), Matrix.identity(3).inverse);
    }
    output.must_include "\n  100  1/10/10/1\n  010  0/11/10/1\n  001  0/10/11/1\n"
  end

  it "should print raw data logging" do
    output = capture_stdout {
      load "././app/log.rb";
      input_data = Matrix.identity(2)
      entity ="Cthulhu"
      Log.display_raw_data(input_data, entity);
    }
    output.must_include "\nCthulhu file contents:\n\n  10\n  01\n"
  end

end
