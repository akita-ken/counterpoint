require 'mandrill' # mandrill-api gem

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :logs, dependent: :destroy

  def self.send_daily_emails
    m = Mandrill::API.new
    ac = ActionController::Base.new()

    message = {
      :from_name => "Counterpoint",
      :from_email => "reply@counterpoint.cflee.net",
      :to => User.all.map { |u| {:email => u.email, :name => u.email, :type => 'to'} },
      :subject => "What did you do today? - #{Date.current.to_formatted_s(:rfc822)}",
      :html => ac.render_to_string('mailer/daily_prompt', :layout => false),
      :merge_vars => [],
      :preserve_recipients => false
    }
    sending = m.messages.send message
  end
end
