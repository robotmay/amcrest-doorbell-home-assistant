# amcrest-doorbell-home-assistant

This is an extremely basic event bus wrangler that takes events from an odd doorbell API and sends them to a Home Assistant webhook. Or, er, any other webhook, I suppose.

It's simple because a doorbell always has to work, and `amcrest2mqtt` is quite a bit more complex and covers a lot of other devices. This project instead cares only about events, and I personally only care about the AD410 doorbell which I own (it should also work for the AD110).

## How to use

Run it in docker. Set the following env vars:

`WEBHOOK_URL`: The URL of a Home Assistant (or something else) webhook trigger in an automation
`AMCREST_HOST`: The hostname/IP of your doorbell
`AMCREST_USER`: The admin username of the doorbell (probably `admin`)
`AMCREST_PASS`: The admin password

There are plenty of log entries for debugging but it should be pretty straight-forward. All events will be forwarded to the webhook address.

## Does it work?

Yes
