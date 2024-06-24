class Scheduler::UpdateJobService 
  def self.update_schedule(schedule, interval, sched_name, start_time, end_time, hour, minutes, sched_params)
    cron_expression = "*/#{minutes.to_s} #{start_time}-#{end_time} * * *"
    job = Sidekiq::Cron::Job.find(schedule.name)
    if job
      if schedule.update(sched_params.except(:active))
        puts "nice"
      end
      job.destroy
    end
    Sidekiq::Cron::Job.create(name: sched_name, cron: cron_expression, class: 'MyWorker')
    new_job = Sidekiq::Cron::Job.find(schedule.name)
    if  schedule.active == false  
      new_job.disable!
      schedule.update(active: false)
    else 
      new_job.enable!
      schedule.update(active: true)
    end
  end
end