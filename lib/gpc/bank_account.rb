require 'czech_bank_account'

using Gpc::Refinements

module Gpc
  module BankAccount
    def self.parse(account)
      prefix = account[0..5].remove_leading_zeroes
      account = account[6..-1].remove_leading_zeroes
      account = [prefix, account].select { !_1.empty? }.join('-')

      validation_result = CzechBankAccount.validate(account, 'xxxx')
      if validation_result == [:unknown_bank_code]
        return account
      end

      translated = translate_from_internal_system(account)
      validation_result = CzechBankAccount.validate(translated, 'xxxx')
      if validation_result == [:unknown_bank_code]
        return translated
      end

      account
    end

    def self.translate_from_internal_system(internal_number)
      [ internal_number[10..15],
        "#{"#{internal_number[4..8]}#{internal_number[3]}#{internal_number[9]}#{internal_number[1..2]}#{internal_number[0]}".remove_leading_zeroes}"
      ].select(&:present?).join('-')
    end
  end
end
