# frozen_string_literal: true

FactoryBot.define do
  factory :slot do
    user_email { FFaker::Internet.email }
    sequence(:start_datetime) { |n| DateTime.now.beginning_of_day + n.hours }
    sequence(:end_datetime) { |n| DateTime.now.beginning_of_day + (1 + n).hours }
  end
end
