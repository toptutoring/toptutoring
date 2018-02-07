module Webhooks
  class DwollaController < ApplicationController
    # Only skipping because we validate ourselves
    skip_before_action :verify_authenticity_token
    before_action :verify_signature

    def update
      event = DwollaEvent.find_by(event_id: params[:id])
      if event
        Rails.logger.info "\e[31mDwolla event already reported\e[0m"
        head :already_reported
      else
        process_event
        DwollaEvent.create(event_id: params[:id])
        head :ok
      end
    end

    private

    def process_event
      resource = params[:_links][:resource][:href]
      case params[:topic]
      when "mass_payment_completed"
        DwollaMassPayUpdateService.perform!(resource)
      when "transfer_cancelled", "transfer_failed"
        DwollaCompleteTransferService.perform!(resource, "failed")
      when "transfer_completed"
        DwollaCompleteTransferService.perform!(resource, "paid")
      end
    end

    def verify_signature
      payload_body = request.body.read
      request_signature = request.headers["X-Request-Signature-Sha-256"]
      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"),
                                          ENV["DWOLLA_WEBHOOK_SECRET"],
                                          payload_body)
      unless Rack::Utils.secure_compare(signature, request_signature)
        head :unauthorized
      end
    end
  end
end
