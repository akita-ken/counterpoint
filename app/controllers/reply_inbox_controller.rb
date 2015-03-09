class ReplyInboxController < ApplicationController
  include Mandrill::Rails::WebHookProcessor
end
