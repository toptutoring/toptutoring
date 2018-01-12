module DwollaServiceStub
  Request = Struct.new(:success?, :response)

  def token_refresh_stub
    token_service = class_double("DwollaTokenRefresh").as_stubbed_const
    expect(dwolla_service).to receive(:perform!) do 
      DWOLLA_CLIENT.tokens.new(access_token: user.access_token,
                               refresh_token: user.refresh_token)
    end
  end

  def mass_pay_stub(result, expected_content) 
    dwolla_service = class_double("DwollaService").as_stubbed_const
    expect(dwolla_service).to receive(:request).twice do |arg1, _|
      if arg1 == :mass_payment
        Request.new(result, "url")
      else
        Request.new(result, expected_content)
      end
    end
  end

  def failed_mass_pay_stub(message)
    dwolla_service = class_double("DwollaService").as_stubbed_const
    expect(dwolla_service).to receive(:request) do 
      Request.new(false, [message])
    end
  end
end

RSpec.configure do |config|
  config.include DwollaServiceStub
end
