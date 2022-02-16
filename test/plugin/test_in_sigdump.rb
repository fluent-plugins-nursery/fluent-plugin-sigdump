require 'helper'

class SigdumpInputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def test_configure
    # TODO
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Input.new(Fluent::Plugin::SigdumpInput).configure(conf)
  end
end
