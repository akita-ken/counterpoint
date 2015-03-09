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
        duration = 0.0
        description = line.chomp
        first_word = description.split.first
        if (true if Float(first_word) rescue false)
          # grab the duration as a number
          duration = first_word.to_f
          # remove the first word
          description = description.split[1..-1].join(' ')
        end

        log = user.logs.new
        log.description = description
        log.date = Date.current # current assumption
        log.duration = duration
        log.save
      end
    end
  end
end
