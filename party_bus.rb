require "rubygems"
require "bundler"
require "logger"

Bundler.require

require "./lib/amcrest_doorbell"

logger = Logger.new("/proc/1/fd/1")
logger.level = Logger::INFO

webhook_url = ENV["WEBHOOK_URL"]

doorbell = AmcrestDoorbell.new(
  host: ENV["AMCREST_HOST"],
  username: ENV["AMCREST_USER"],
  password: ENV["AMCREST_PASS"]
)

default_timeout = 0
timeout_increment = 0.1
timeout = default_timeout

connection_success = -> do
  logger.info("Connected")

  unless timeout == default_timeout
    logger.info("Resetting reconnection delay to #{default_timeout} second(s)")
    timeout = default_timeout
  end
end

loop do
  logger.info("Connecting to event bus. Next reconnection delay is #{timeout} second(s)")

  doorbell.event_stream(success: connection_success) do |event|
    logger.info("Received event: #{event.code}")

    webhook = Faraday.post(webhook_url, event.to_json, { "Content-Type" => "application/json" })
    logger.info("Webhook response: #{webhook.status}")

    case
    # Doorbell button pressed. Probably.
    when event.code == "_DoTalkAction_"
      logger.info("Doorbell button pressed")
    end
  end

rescue Faraday::Error => ex
  logger.error("Connection error: #{ex}")

  # Try not to DOS the doorbell by backing off retries
  sleep timeout
  timeout += timeout_increment
end
