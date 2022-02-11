module Gpc
  class Statement
    attr_accessor :account, :identifier, :old_balance_date, :old_balance, :new_balance, :debit_turnover, :credit_turnover, :number, :date, :transactions

    def initialize(attrs)
      attrs.each do |key, value|
        public_send("#{key}=", value)
      end
    end
  end
end
