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
    interval = params[:schedule][:interval].to_i
    sched_name = params[:schedule][:name]
    cron_expression = "*/#{interval} * * * *"
    
    @sched = Schedule.find(params[:id])

    job = Sidekiq::Cron::Job.find(sched_name)
    if job
      existing_job = Schedule.find_by(name: job.name)
      existing_job.destroy if existing_job
      job.destroy
    end
    Sidekiq::Cron::Job.create(name: sched_name, cron: cron_expression, class: 'MyWorker')
    Schedule.create(name: sched_name, interval: interval, active: true)
    
    
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
    cron_expression = "*/#{@schedule.interval} * * * *"
    new_running_job = Sidekiq::Cron::Job.create(name: @schedule.name, cron: cron_expression, class: 'MyWorker')
    new_created_schedule = Schedule.create(name: @schedule.name, interval: @schedule.interval, active: true)
    @schedule.destroy
    redirect_to schedules_path
  end
  

  private

  def set_schedule 
    @schedule = Schedule.find(params[:id])
  end
end
