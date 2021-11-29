require "rubygems"
require "bundler"

Bundler.require

class AmcrestDoorbell
  def initialize(host:, username:, password:)
    @host = host

    @conn = Faraday.new(url: base_url) do |f|
      f.request :digest, username, password
      f.adapter Faraday.default_adapter
    end
  end

  def event_stream(codes: %w(All))
    codes = codes.join(",")

    @conn.get("/cgi-bin/eventManager.cgi?action=attach&codes=[#{codes}]") do |req|
      p req

      req.options.on_data = -> (chunk, overall_received_bytes) do
        yield chunk
      end
    end
  end

  private

  def base_url
    "http://#{@host}"
  end
end


client.event_stream do |chunk|
  p chunk
end
