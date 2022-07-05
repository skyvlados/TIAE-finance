module OperationsHelper
    CURRENCIES = {
       usd: "$",
       rub: "₽",
       eur: "€",
    }

    def human_amount(amount, currency)
        "#{amount} #{CURRENCIES.fetch(currency.downcase.to_sym, currency)}"
    end
end
