# frozen_string_literal: true

module OperationsHelper
  CURRENCIES = {
    usd: '$',
    rub: '₽',
    eur: '€'
  }.freeze

  def human_amount(amount, currency)
    "#{amount} #{CURRENCIES.fetch(currency.downcase.to_sym, currency.upcase)}"
  end

  def button_text
    case controller.action_name
    when 'new' then 'Save'
    when 'edit' then 'Edit'
    else 'Submit'
    end
  end
end
