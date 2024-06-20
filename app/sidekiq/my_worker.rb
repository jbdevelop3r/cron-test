class MyWorker
  include Sidekiq::Worker

  def perform
    puts "Job is running!"
  end
end

