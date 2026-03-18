class Notifications::SchedulerPollerJob < ApplicationJob
  queue_as :notifications

  def perform
    Notification.pending_to_send.find_each do |notification|
      Notifications::ProcessorService.process(notification)
    end
  end
end
