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
    assert_equal(900, d.instance.scrape_interval)
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

  def test_output_to_new_dir
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

  def test_output_to_existing_dir
    FileUtils.mkdir_p(RESULT_DIR)

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
    return unless Dir.exist?(RESULT_DIR)

    FileUtils.rm(all_result_filepaths)
    # Need to remove the directory in order to check the plugin can create the directly.
    Dir.rmdir(RESULT_DIR)
  end
end
