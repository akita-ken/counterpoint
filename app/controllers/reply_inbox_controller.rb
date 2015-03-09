class ReplyInboxController < ApplicationController
  include Mandrill::Rails::WebHookProcessor
  authenticate_with_mandrill_keys! ENV["MANDRILL_WEBHOOK_KEY"]

  def handle_inbound(event_payload)
    logger.debug "From:: #{event_payload['msg']['from_email']}"
    logger.debug "Message text:: #{event_payload['msg']['text']}"
    from_email = event_payload['msg']['from_email']
    parsed_body = EmailReplyParser.parse_reply(event_payload['msg']['text'])

    user = User.find_by_email(from_email)
    unless user.nil?
      parsed_body.lines.each do |line|
        log = user.logs.new
        log.description = line.chomp
        log.date = Date.current
        log.duration = line.split.first.to_f
        log.save
      end
    end
  end
end
