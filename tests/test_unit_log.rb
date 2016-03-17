require 'test_helper'
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

  it "should print debug logging when the DEBUG env var is activated" do
    output = capture_stdout {
      ENV['DEBUG'] = "yes";
      load "././app/config.rb";
      load "././app/log.rb";
      Log.debug("Doot Doot");
    }
    output.must_include "\nDoot Doot"
  end

  it "should not print debug logging when the DEBUG env var is not activated" do
    output = capture_stdout {
      ENV['DEBUG'] = nil;
      load "././app/config.rb";
      load "././app/log.rb";
      Log.debug("Doot Doot");
    }
    output.must_equal ""
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

  it "should print double_tab logging" do
    output = capture_stdout {
      load "././app/log.rb";
      boxmap = Matrix.identity(3);
      puzzle = Matrix.zero(3);
      Log.double_tab(boxmap, puzzle);
    }
    output.must_equal "\n  100  000\n  010  000\n  001  000\n"
  end

  it "should print error logging" do
    output = capture_stdout {
      load "././app/log.rb";
      Log.error("A handleable error condition.");
    }
    output.must_include "ERROR"
    output.must_include "A handleable error condition"
  end

  it "should print info logging" do
    output = capture_stdout {
      load "././app/log.rb";
      Log.info("Generic (useful) information about system operation.");
    }
    output.must_include "Generic (useful) information about system operation."
  end

  it "should print success logging" do
    output = capture_stdout {
      $duration_start = Time.now
      load "././app/log.rb";
      puzzle = Matrix.identity(2);
      Log.success(puzzle);
    }
    output.must_include "SUCCESS"
    output.must_include "Solution found in:"
    output.must_include "  10\n  01"
  end

  it "should print tab logging" do
    output = capture_stdout {
      load "././app/log.rb";
      puzzle = Matrix.identity(2);
      Log.tab(puzzle);
    }
    output.must_equal "\n  10\n  01\n"
  end

end
