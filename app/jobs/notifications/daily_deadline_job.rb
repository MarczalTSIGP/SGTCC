class Notifications::DailyDeadlineJob < ApplicationJob
  queue_as :notifications

  def perform
    Notifications::Hooks.daily_deadline_notifications
  end
end
