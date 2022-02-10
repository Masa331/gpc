# frozen_string_literal: true

require "test_helper"
require "pry"

class TestGpc < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Gpc::VERSION
  end

  def test_gopay_statement_parse
    data = File.read('./test/files/gopay.gpc')
    gpc = Gpc.parse(data)

    Gpc.pp(gpc)

    assert false
  end
end
