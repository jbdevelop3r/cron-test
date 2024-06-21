class SchedulesController < ApplicationController
  before_action :set_schedule, except: [:update, :index]

  def index 
    @schedules = Schedule.all
  end

  def show 
  end

  def edit
  end

  def update
    @schedule = Schedule.find(params[:id])
    interval = params[:schedule][:minutes].to_i
    sched_name = params[:schedule][:name]
    start_time = params[:schedule][:start_time]
    end_time = params[:schedule][:end_time]
    hour = params[:schedule][:hour]
    minutes = params[:schedule][:minutes].to_i
    cron_expression = "*/#{minutes.to_s} #{start_time}-#{end_time} * * *"
    job = Sidekiq::Cron::Job.find(@schedule.name)
    if job
      if @schedule.update(schedule_params.except(:active))
        puts "nice"
      end
      job.destroy
    end
    Sidekiq::Cron::Job.create(name: sched_name, cron: cron_expression, class: 'MyWorker')
    new_job = Sidekiq::Cron::Job.find(@schedule.name)
    if  @schedule.active == false  
      new_job.disable!
      @schedule.update(active: false)
    else 
      new_job.enable!
      @schedule.update(active: true)
    end
    redirect_to schedules_path, notice: "Schedule updated to every #{interval} minutes."
  end


  def disable_job 
    @schedule = Schedule.find(params[:id])
    @job = Sidekiq::Cron::Job.find(@schedule.name)
    @job.disable!
    @schedule.update(active: false)
    redirect_to schedules_path
  end

  def enable_job 
    @job = Sidekiq::Cron::Job.find(@schedule.name)
    @job.destroy
    @schedule = Schedule.find(params[:id])
    cron_expression = "*/#{@schedule.minutes} #{@schedule.start_time}-#{@schedule.end_time} * * *"
    new_running_job = Sidekiq::Cron::Job.create(name: @schedule.name, cron: cron_expression, class: 'MyWorker')
    if @schedule.update(active: true)
      puts "updated"
    end
    redirect_to schedules_path
  end
  

  private

  def set_schedule 
    @schedule = Schedule.find(params[:id])
  end

  def schedule_params 
    params.require(:schedule).permit(:name, :interval, :active, :start_time, :end_time, :hour, :minutes)
  end
end
