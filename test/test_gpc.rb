# frozen_string_literal: true

require "test_helper"
require "pry"

class TestGpc < Minitest::Test
  def test_gopay_statement
    data = File.read('./test/files/gopay.gpc')
    gpc = Gpc.parse(data)

    assert_equal 1, gpc.size
    assert_equal 17, gpc.first.transactions.size

    statement = gpc.first
    assert_equal '100046815', statement.account
    assert_equal '000', statement.number
    assert_equal 'UCET CZK', statement.identifier
    assert_equal Date.parse('9.9.2020'), statement.old_balance_date
    assert_equal Date.parse('10.9.2020'), statement.date
    assert_equal BigDecimal('160.43'), statement.new_balance
    assert_equal BigDecimal('4040.81'), statement.old_balance
    assert_equal BigDecimal('210.3'), statement.credit_turnover
    assert_equal BigDecimal('-4090.68'), statement.debit_turnover

    payment = statement.transactions.first
    assert_equal '100046815', payment.account
    assert_equal '', payment.counterparty_account
    assert_equal '8998192720', payment.id
    assert_equal BigDecimal('1.11'), payment.amount
    assert_equal '2', payment.accounting_code
    assert_equal '', payment.variable_symbol
    assert_equal '', payment.counterparty_bank_code
    assert_equal '', payment.specific_symbol
    assert_equal Date.parse('9.9.2020'), payment.date
    assert_equal 'GOPAY-PLATBA', payment.note
    assert_equal '0', payment.change_code
    assert_equal '1102', payment.data_type
    assert_equal Date.parse('9.9.2020'), payment.due_date
    assert_nil payment.counterparty

    payment = statement.transactions[-3]
    assert_equal '100046815', payment.account
    assert_equal '670100-2210356506', payment.counterparty_account
    assert_equal '8999192873', payment.id
    assert_equal BigDecimal('10'), payment.amount
    assert_equal '2', payment.accounting_code
    assert_equal '100046815', payment.variable_symbol
    assert_equal '6210', payment.counterparty_bank_code
    assert_equal '', payment.specific_symbol
    assert_equal Date.parse('10.9.2020'), payment.date
    assert_equal 'GOPAY-DOBITI-UCTU', payment.note
    assert_equal '0', payment.change_code
    assert_equal '1102', payment.data_type
    assert_equal Date.parse('10.9.2020'), payment.due_date
    assert_equal '670100-2210356506/6210', payment.counterparty
  end

  def test_raiffeisen_bank_statement
    data = File.read('./test/files/rb.gpc', encoding: 'Windows-1250:UTF-8')
    gpc = Gpc.parse(data)

    assert_equal 1, gpc.size
    assert_equal 1, gpc.first.transactions.size
    statement = gpc.first

    payment = statement.transactions.first
    assert_equal '300840378', payment.account
    assert_equal '', payment.counterparty_account
    assert_equal '1000000000115', payment.id
    assert_equal BigDecimal('-590.5'), payment.amount
    assert_equal '1', payment.accounting_code
    assert_equal '405000020', payment.variable_symbol
    assert_equal '', payment.counterparty_bank_code
    assert_equal '2320112373', payment.specific_symbol
    assert_equal Date.parse('21.1.2022'), payment.date
    assert_equal 'Transakce platební k', payment.note
    assert_equal '0', payment.change_code
    assert_equal '0203', payment.data_type
    assert_equal Date.parse('21.1.2022'), payment.due_date
    assert_equal 'Místo: BENZINA CS 0256', payment.av1
    assert_equal 'NYMBURK', payment.av2
    assert_equal 'Částka: 590.5 CZK 19.01.2022', payment.av3
    assert_equal '', payment.av4
    assert_nil payment.counterparty
  end

  def test_komercni_banka_statement
    data = File.read('./test/files/kb.gpc', encoding: 'Windows-1250:UTF-8')
    gpc = Gpc.parse(data)

    assert_equal 2, gpc.size

    statement = gpc.first
    assert_equal '35-2967671567', statement.account
  end
end
