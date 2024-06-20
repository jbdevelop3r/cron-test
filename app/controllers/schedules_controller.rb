class SchedulesController < ApplicationController
  def edit
  end

  def update
    interval = params[:interval].to_i
    cron_expression = "*/#{interval} * * * *"
    binding.b
    job = Sidekiq::Cron::Job.find('my_job')
    if job
      job.destroy
    end
    Sidekiq::Cron::Job.create(name: 'my_job', cron: cron_expression, class: 'MyWorker')
    binding.b
    redirect_to edit_schedule_path, notice: "Schedule updated to every #{interval} minutes."
    updated_job = Sidekiq::Cron::Job.find('my_job')
    binding.b
  end
end
