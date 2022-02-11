module Gpc
  class Transaction
    attr_accessor :date, :due_date, :amount, :account, :counterparty_account, :variable_symbol, :constant_symbol, :specific_symbol, :counterparty, :note, :id, :bank_id, :counterparty_bank_code, :counterparty_date, :comment, :av1, :av2, :av3, :av4, :accounting_code, :change_code, :data_type

    def initialize(attrs)
      attrs.each do |key, value|
        public_send("#{key}=", value)
      end
    end
  end
end
