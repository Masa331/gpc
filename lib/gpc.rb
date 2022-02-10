# frozen_string_literal: true

require_relative 'gpc/parser'

module Gpc
  VERSION = "0.1.0"
  class Error < StandardError; end

  def self.parse(data)
    Parser.call(data)
  end

  def self.pp(statements)
    statements.each do |statement|
      transactions = statement.delete_field(:transactions)
      puts(statement)

      transactions.each do |transaction|
        puts("--#{transaction}")
      end

      puts
    end
  end
end
