class ReplyInboxController < ApplicationController
  include Mandrill::Rails::WebHookProcessor
  authenticate_with_mandrill_keys! ENV["MANDRILL_WEBHOOK_KEY"]

  def handle_inbound(event_payload)
    logger.debug "Message:: #{event_payload['msg']['text']}"

  end
end
