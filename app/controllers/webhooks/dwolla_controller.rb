module Webhooks
  class DwollaController < ApplicationController
    # Only skipping because we validate ourselves
    skip_before_action :verify_authenticity_token
    before_action :verify_signature, :set_event

    def update
      @event.persisted? ? already_reported : process_event
    end

    private

    def set_event
      @event = DwollaEvent.where(event_id: params.require(:id))
        .first_or_initialize do |event|
        event.topic = params[:topic]
        event.resource_url = params[:_links][:resource][:href]
      end
    end

    def already_reported
      Rails.logger.info "\e[31mDwolla event already reported\e[0m"
      head :already_reported
    end

    def log_process
      process = @event.topic + " - " + @event.resource_url
      Rails.logger.info "\e[31mProcessing Dwolla event: #{process}\e[0m"
    end

    def process_event
      log_process
      case @event.topic
      when "mass_payment_completed"
        result = DwollaMassPayUpdateService.perform!(@event)
      when "transfer_cancelled", "transfer_failed", "transfer_completed"
        result = DwollaCompleteTransferService.perform!(@event)
      end
      @event.save if result
      head :ok
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
