# frozen_string_literal: true

require "test_helper"
require "pry"

class TestGpc < Minitest::Test
  def test_gopay_statement
    data = File.read('./test/files/gopay.gpc')
    gpc = Gpc.parse(data)

    assert gpc.size == 1

    statement = gpc.first
    assert_equal '100046815', statement.account
    assert_equal '074', statement.type
    assert_equal '000', statement.number
    assert_equal 'UCET CZK', statement.identifier
    assert_equal Date.parse('9.9.2020'), statement.old_balance_date
    assert_equal Date.parse('10.9.2020'), statement.date
    assert_equal BigDecimal('160.43'), statement.new_balance
    assert_equal BigDecimal('4040.81'), statement.old_balance
    assert_equal BigDecimal('210.3'), statement.credit_turnover
    assert_equal BigDecimal('-4090.68'), statement.debit_turnover

    payment = statement.transactions.first
    assert_equal '075', payment.type
    assert_equal '100046815', payment.account
    assert_equal '', payment.counterparty_account
    assert_equal '8998192720', payment.id
    assert_equal BigDecimal('1.11'), payment.amount
    assert_equal '2', payment.accounting_code
    assert_equal '', payment.variable_symbol
    assert_equal '00', payment.filler
    assert_equal '', payment.counterparty_bank_code
    assert_equal '', payment.specific_symbol
    assert_equal Date.parse('9.9.2020'), payment.date
    assert_equal 'GOPAY-PLATBA', payment.note
    assert_equal '0', payment.change_code
    assert_equal '1102', payment.data_type
    assert_equal Date.parse('9.9.2020'), payment.due_date
    assert_nil payment.counterparty

    payment = statement.transactions[-3]
    assert_equal '075', payment.type
    assert_equal '100046815', payment.account
    assert_equal '670100-2210356506', payment.counterparty_account
    assert_equal '8999192873', payment.id
    assert_equal BigDecimal('10'), payment.amount
    assert_equal '2', payment.accounting_code
    assert_equal '100046815', payment.variable_symbol
    assert_equal '00', payment.filler
    assert_equal '6210', payment.counterparty_bank_code
    assert_equal '', payment.specific_symbol
    assert_equal Date.parse('10.9.2020'), payment.date
    assert_equal 'GOPAY-DOBITI-UCTU', payment.note
    assert_equal '0', payment.change_code
    assert_equal '1102', payment.data_type
    assert_equal Date.parse('10.9.2020'), payment.due_date
    assert_equal '670100-2210356506/6210', payment.counterparty
  end
end
