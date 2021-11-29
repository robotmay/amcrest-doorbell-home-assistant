require "json"

class AmcrestDoorbell
  def initialize(host:, username:, password:)
    @host = host

    @conn = Faraday.new(url: base_url) do |f|
      f.request :digest, username, password
      f.adapter Faraday.default_adapter
    end
  end

  def event_stream(success: nil, codes: %w(All))
    codes = codes.join(",")

    @conn.get("/cgi-bin/eventManager.cgi?action=attach&codes=[#{codes}]") do |req|
      success.call unless success.nil?

      req.options.on_data = -> (chunk, overall_received_bytes) do
        lines = chunk.split("\r\n").map(&:strip)

        lines.each do |line|
          if line.start_with?("Code=")
            yield Event.new(line)
          end
        end
      end
    end
  end

  private

  def base_url
    "http://#{@host}"
  end

  class Event
    def initialize(raw)
      @raw = raw
    end

    def code
      key_value_hash["Code"]
    end

    def action
      key_value_hash["action"]
    end

    def index
      key_value_hash["index"].to_i
    end

    def data
      data = key_value_hash["data"]

      return if data.nil? || data == ""

      JSON.parse(key_value_hash["data"])
    end

    def to_json
      JSON.generate({
        code: code,
        action: action,
        index: index,
        data: data
      })
    end

    private

    def key_value_hash
      arr = @raw.split(";").map do |str|
        str.split("=", 2)
      end

      arr.to_h
    end
  end
end
