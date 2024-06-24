class MyWorker
  include Sidekiq::Worker

  def perform
    puts "Job is running!"
    Rails.logger.info "Job ended at #{Time.current}"
  end
end

