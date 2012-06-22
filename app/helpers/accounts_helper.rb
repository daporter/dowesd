module AccountsHelper
  def format_amount(amount)
    number_to_currency(amount.to_f / 100)
  end
end
