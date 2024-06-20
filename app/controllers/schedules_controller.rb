class SchedulesController < ApplicationController
  def edit
  end

  def update
    interval = params[:interval].to_i
    sched_name = params[:name]
    cron_expression = "*/#{interval} * * * *"
    id = 5
    @sched = Schedule.find(id)
    job = Sidekiq::Cron::Job.find('my_job')
    if job
      existing_job = Schedule.find_by(name: job.name)
      existing_job.destroy
      job.destroy
    end
    Sidekiq::Cron::Job.create(name: sched_name, cron: cron_expression, class: 'MyWorker')
    Schedule.create(name: sched_name, interval: interval)
    redirect_to edit_schedule_path, notice: "Schedule updated to every #{interval} minutes."
  end
end
