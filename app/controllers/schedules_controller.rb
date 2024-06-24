class SchedulesController < ApplicationController
  before_action :set_schedule, except: [:index]

  def index 
    @schedules = Schedule.all
  end

  def show 
  end

  def edit
  end

  def update
    sched_params = schedule_params
    schedule = @schedule
    interval = params[:schedule][:minutes].to_i
    sched_name = params[:schedule][:name]
    start_time = params[:schedule][:start_time]
    end_time = params[:schedule][:end_time]
    hour = params[:schedule][:hour]
    minutes = params[:schedule][:minutes].to_i
    update_schedule = Scheduler::UpdateJobService.update_schedule(schedule, interval, sched_name, start_time, end_time, hour, minutes,sched_params)
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
