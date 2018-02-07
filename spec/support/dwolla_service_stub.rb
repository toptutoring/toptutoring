module DwollaServiceStub
  Request = Struct.new(:success?, :response)

  def dwolla_stub_success(expected_content) 
    stub(true, expected_content)
  end

  def dwolla_stub_failure(expected_content)
    stub(false, expected_content)
  end

  def stub(result, expected_content)
    dwolla_service = class_double("DwollaService").as_stubbed_const
    expect(dwolla_service).to(receive(:request)).at_most(:twice) do 
      Request.new(result, expected_content)
    end
  end
end

RSpec.configure do |config|
  config.include DwollaServiceStub
end
