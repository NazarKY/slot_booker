class Slot < ApplicationRecord
  validates :start_datetime, :end_datetime, :user_email, :status, presence: true
  validates_format_of :user_email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  enum status: %i[in_progress completed cancelled]

  before_create :assign_uuid

  scope :day_booked_slots, ->(day) { where(start_datetime: day.beginning_of_day..day.end_of_day) }

  TIMESLOTS = [
    { startTime: '00:00', endTime: '01:00' }, { startTime: '01:00', endTime: '02:00' },
    { startTime: '02:00', endTime: '03:00' }, { startTime: '03:00', endTime: '04:00' },
    { startTime: '04:00', endTime: '05:00' }, { startTime: '05:00', endTime: '06:00' },
    { startTime: '06:00', endTime: '07:00' }, { startTime: '07:00', endTime: '08:00' },
    { startTime: '08:00', endTime: '09:00' }, { startTime: '09:00', endTime: '10:00' },
    { startTime: '10:00', endTime: '11:00' }, { startTime: '11:00', endTime: '12:00' },
    { startTime: '12:00', endTime: '13:00' }, { startTime: '13:00', endTime: '14:00' },
    { startTime: '14:00', endTime: '15:00' }, { startTime: '15:00', endTime: '16:00' },
    { startTime: '16:00', endTime: '17:00' }, { startTime: '17:00', endTime: '18:00' },
    { startTime: '18:00', endTime: '19:00' }, { startTime: '19:00', endTime: '20:00' },
    { startTime: '20:00', endTime: '21:00' }, { startTime: '21:00', endTime: '22:00' },
    { startTime: '22:00', endTime: '23:00' }, { startTime: '23:00', endTime: '24:00' }
  ].freeze

  class << self
    def available_timeslots_with_group(day)
      timeslots = available_timeslots(day)
      group_id = 0
      timeslots.each_cons(2) do |couple|
        couple.first[:group] = group_id
        couple.first[:endTime] == couple.last[:startTime] ? couple.last[:group] = group_id : group_id += 1
      end

      timeslots
    end

    def available_timeslots(day)
      booked_timeslots = booked_timeslots(day)
      TIMESLOTS.each_with_object([]) do |timeslot, result|
        result << timeslot unless timeslot_in_range?(timeslot, booked_timeslots)
      end
    end

    def booked_timeslots(day)
      day_booked_slots(day).map { |slot| { startTime: slot.start_time, endTime: slot.end_time } }
                           .uniq { |timeslot| timeslot[:startTime] }
    end

    def timeslot_in_range?(timeslot, timeslots)
      timeslots.any? { |slot| (slot[:startTime]...slot[:endTime]).cover?(timeslot[:startTime]) }
    end
  end

  def start_time
    start_datetime.strftime('%H:%M')
  end

  def end_time
    time = end_datetime.strftime('%H:%M')
    return '24:00' if time == '00:00'

    time
  end

  private

  def assign_uuid
    self.uuid = SecureRandom.uuid
  end
end
