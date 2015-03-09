class ReplyInboxController < ApplicationController
  include Mandrill::Rails::WebHookProcessor
  authenticate_with_mandrill_keys! ENV["MANDRILL_WEBHOOK_KEY"]
end
