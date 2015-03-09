class LogsController < ApplicationController
  before_action :authenticate_user!

  def summary
    # assign default parameters
    params[:date] ||= Date.today
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
    @logs = Log.where(date: start_time..end_time).
      order(date: :desc, duration: :desc, description: :asc)
  end

  def index
    @logs = Log.all
  end

  def new
    @log = Log.new
  end

  def edit
    @log = Log.find(params[:id])
  end

  def destroy
    @log = Log.find(params[:id])
    @log.destroy

    redirect_to log_path
  end

  def create
    @log = Log.new(log_params)

    if @log.save
      redirect_to @log
    else
      render 'new'
    end
  end

  def update
    @log = Log.find(params[:id])

    if @log.update(log_params)
      redirect_to @log
    else
      render 'edit'
    end
  end

  def show
    @log = Log.find(params[:id])
  end

  private
    def log_params
      params.require(:log).permit(:date, :description, :duration)
    end
end
