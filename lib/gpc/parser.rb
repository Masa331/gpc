require 'bigdecimal'
require_relative 'refinements'
require_relative 'bank_account'
require 'date'

using Gpc::Refinements

module Gpc
  class Parser

    HEADER_SECTIONS = { type: 3, account: 16, identifier: 20, old_balance_date: 6, old_balance: 14, old_balance_sign: 1, new_balance: 14, new_balance_sign: 1, debit_turnover: 14, debit_turnover_sign: 1, credit_turnover: 14, credit_turnover_sign: 1, number: 3, date: 6, filler: 14 }
    TRANSACTION_SECTIONS = { type: 3, account: 16, counterparty_account: 16, id: 13, amount: 12, accounting_code: 1, variable_symbol: 10, filler: 2, counterparty_bank_code: 4, constant_symbol: 4, specific_symbol: 10, date: 6, note: 20, change_code: 1, data_type: 4, due_date: 6 }

    def self.call(data)
      new(data).parse
    end

    def initialize(data)
      @data = data
    end

    def parse
      @statements = []
      @statement = { transactions: [] }

      @data.lines.each do |line|
        type = line[0, 3]

        case type
        when '074'
          if @statement[:transactions].any? || @statement.keys.size > 1
            @statements << OpenStruct.new(@statement)
            @statement = { transactions: [] }
          end

          sections = line.sections(HEADER_SECTIONS)
          sections[:credit_turnover] = BigDecimal("#{sections.delete(:credit_turnover_sign)}#{sections[:credit_turnover]}") / 100
          sections[:debit_turnover] = BigDecimal("#{sections.delete(:debit_turnover_sign)}#{sections[:debit_turnover]}") / 100
          sections[:new_balance] = BigDecimal("#{sections.delete(:new_balance_sign)}#{sections[:new_balance]}") / 100
          sections[:old_balance] = BigDecimal("#{sections.delete(:old_balance_sign)}#{sections[:old_balance]}") / 100
          sections[:date] = date(sections[:date])
          sections[:old_balance_date] = date(sections[:old_balance_date])
          sections[:identifier].strip!
          sections[:account] = Gpc::BankAccount.parse(sections[:account])

          @statement.merge!(sections)
        when '075'
          transaction = line.sections(TRANSACTION_SECTIONS)
          transaction[:date] = date(transaction[:date])
          transaction[:due_date] = date(transaction[:due_date])
          sign =
            case transaction[:accounting_code]
            when '1' then -1
            when '2' then 1
            else
              fail Gpc::Error.new("unknown accounting code: #{transaction[:accounting_code]}")
            end

          transaction[:amount] = BigDecimal(transaction[:amount]) / 100 * sign
          transaction[:account] = Gpc::BankAccount.parse(transaction[:account])
          transaction[:counterparty_account] = Gpc::BankAccount.parse(transaction[:counterparty_account])
          if transaction[:counterparty_bank_code] == '0000'
            transaction[:counterparty_bank_code] = ''
          end
          transaction[:variable_symbol] = transaction[:variable_symbol].remove_leading_zeroes
          transaction[:constant_symbol] = transaction[:constant_symbol].remove_leading_zeroes
          transaction[:specific_symbol] = transaction[:specific_symbol].remove_leading_zeroes
          transaction[:counterparty] =
          if transaction[:counterparty_account] != '' && transaction[:counterparty_bank_code] != ''
            [transaction[:counterparty_account], transaction[:counterparty_bank_code]].join('/')
          end
          transaction[:note].strip!
          transaction[:id] = transaction[:id].remove_leading_zeroes

          @statement[:transactions] << OpenStruct.new(transaction)
        else
          # binding.pry
          fail Gpc::Error.new("Unknown line type #{type}")
        end
      end

      if @statement[:transactions].any? || @statement.keys.size > 1
        @statements << OpenStruct.new(@statement)
      end

      @statements
    end

    def date(string)
      Date.strptime(string, '%d%m%y')
    end
  end
end
