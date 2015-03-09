require 'mandrill' # mandrill-api gem

class LogsController < ApplicationController
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def summary
    # assign default parameters
    params[:date] ||= Date.current
    params[:period] ||= 'day'

    # convert from string to Date if necessary
    # no harm if it's already a Date
    params[:date] = params[:date].to_date

    # calculate the start/end Times for period
    if params[:period] == 'day'
      start_time = params[:date].beginning_of_day
      end_time = params[:date].end_of_day
    elsif params[:period] == 'week'
      start_time = params[:date].beginning_of_week
      end_time = params[:date].end_of_week
    elsif params[:period] == 'month'
      start_time = params[:date].beginning_of_month
      end_time = params[:date].end_of_month
    end

    # assign instance variables for view
    @date = params[:date]
    @start_date = start_time.to_date
    @end_date = end_time.to_date
    @logs = current_user.logs.where(date: start_time..end_time).
      order(date: :desc, duration: :desc, description: :asc)
  end

  def send_email
    m = Mandrill::API.new

    message = {
      :from_name => "Counterpoint",
      :from_email => "reply@counterpoint.cflee.net",
      :to => [{:email => current_user.email, :name => current_user.email, :type => 'to'}],
      :subject => "What did you do today? - #{Date.current.to_formatted_s(:rfc822)}",
      :html => render_to_string('mailer/daily_prompt', :layout => false),
      :merge_vars => [],
      :preserve_recipients => false
    }
    sending = m.messages.send message

    redirect_to :controller => 'logs', :action => 'index'
  end

  def index
    @logs = current_user.logs.all.
      order(date: :desc, duration: :desc, description: :asc)
  end

  def new
    @log = current_user.logs.new
  end

  def edit
    @log = current_user.logs.find(params[:id])
  end

  def destroy
    @log = current_user.logs.find(params[:id])
    @log.destroy

    redirect_to log_path
  end

  def create
    @log = current_user.logs.new(log_params)

    if @log.save
      redirect_to @log
    else
      render 'new'
    end
  end

  def update
    @log = current_user.logs.find(params[:id])

    if @log.update(log_params)
      redirect_to @log
    else
      render 'edit'
    end
  end

  def show
    @log = current_user.logs.find(params[:id])
  end

  private
    def log_params
      params.require(:log).permit(:date, :description, :duration)
    end

    def record_not_found
      flash[:alert] = 'Unable to find record'
      redirect_to :controller => 'logs', :action => 'index'
    end
end
