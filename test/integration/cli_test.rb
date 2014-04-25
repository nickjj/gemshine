require_relative '../test_helper'

class TestCLI < Minitest::Unit::TestCase
  include Gemshine::Test

  def test_path
    create_dummy_gemfile

    out, err = capture_subprocess_io do
      gemshine 'path Gemfile'
    end

    assert_match /4 total gems/, out

    system "rm -rf #{TEST_PATH}"
  end

  def test_version
    out, err = capture_subprocess_io do
      gemshine 'version'
    end

    assert_match /Gemshine/, out
  end

  private

    def create_dummy_gemfile
      gems = []
      gems << 'gem "rails", "~> 4.1.0"'
      gems << '       gem "sidekiq", "~> 2.17.4"'
      gems << 'gem "whenever", require: false'
      gems << 'gemwhenever",,,,d,,e'
      gems << 'gem "sdoc", "~> 0.4.0", require: false'
      gems << ' '

      gemfile_path = "#{TEST_PATH}/Gemfile"

      system "mkdir -p #{TEST_PATH}"

      File.open(gemfile_path, 'w+') do |f|
        gems.each { |element| f.puts(element) }
      end
    end
end