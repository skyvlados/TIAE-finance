module OperationsHelper
    CURRENCIES = {
       usd: "$",
       rub: "₽",
       eur: "€",
    }

    def human_amount(amount, currency)
        "#{amount} #{CURRENCIES.fetch(currency.downcase.to_sym, currency)}"
    end

    def button_text
        if controller.action_name == "new"
           return "Save"
        elsif controller.action_name == "edit"
           return "Edit"
        else
           return "Submit"
        end
      end
end
