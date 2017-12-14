class OpenTokRoomsController < ApplicationController
  require "opentok"

  def index
    ot = OpenTok::OpenTok.new ENV.fetch("OPENTOK_API_KEY"), ENV.fetch("OPENTOK_API_SECRET")
    @session_id = "2_MX40NTk5NzM5Mn5-MTUxMjU5MzUzOTkwOX44LzIrQms4NGNHbVZJU1NDZVBhb29nb0t-fg"
    @token_id = ot.generate_token @session_id
  end
end
