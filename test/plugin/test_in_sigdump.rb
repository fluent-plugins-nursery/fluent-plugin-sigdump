require "helper"
require "fluent/plugin/in_sigdump"
require "fileutils"

class SigdumpInputTest < Test::Unit::TestCase
  RESULT_DIR = "test/plugin/result"

  def setup
    Fluent::Test.setup
    clean_result
  end

  def test_configure_default_values
    d = create_driver(%[
      @type sigdump
      dir_path "#{RESULT_DIR}"
    ])
    assert_equal("sigdump", d.instance.tag)
    assert_equal(RESULT_DIR, d.instance.dir_path)
    assert_equal(60, d.instance.scrape_interval)
  end

  def test_configure_customize
    d = create_driver(%[
      @type sigdump
      dir_path "#{RESULT_DIR}"
      scrape_interval 10
    ])
    assert_equal("sigdump", d.instance.tag)
    assert_equal(RESULT_DIR, d.instance.dir_path)
    assert_equal(10, d.instance.scrape_interval)
  end

  def test_configure_invalid
    assert_raise(Fluent::ConfigError) do
      d = create_driver(%[
        @type sigdump
        dir_path "test/plugin/not_existing_dir"
      ])
    end
  end

  def test_output
    d = create_driver(%[
      @type sigdump
      dir_path "#{RESULT_DIR}"
      scrape_interval 3
    ])

    d.run do
      sleep(10)
    end

    assert_equal(true, all_result_filepaths.length >= 2)
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Input.new(Fluent::Plugin::SigdumpInput).configure(conf)
  end

  def all_result_filepaths
    Dir.glob("#{RESULT_DIR}/sigdump_*.txt")
  end

  def clean_result
    FileUtils.rm(all_result_filepaths)
  end
end
