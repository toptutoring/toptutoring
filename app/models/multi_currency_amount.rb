class MultiCurrencyAmount
  APP_SUPPORTED_CURRENCIES = ['usd']

  APP_DEFAULT_CURRENCY = 'usd'

  ZERO_DECIMAL_CURRENCIES = %w(clp jpy)

  # Change amount value to cents value for all currencies
  def self.to_cent(amount, currency)
    if ZERO_DECIMAL_CURRENCIES.any?{ |s| s.casecmp(currency) == 0 }
      amount
    else
      amount_cents * 100.0
    end
  end

  # Change cents value to amount value for all currencies
  def self.from_cent(amount_cents, currency)
    if ZERO_DECIMAL_CURRENCIES.any?{ |s| s.casecmp(currency) == 0 }
      amount_cents
    else
      amount_cents / 100.0
    end
  end
end
