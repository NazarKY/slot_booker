# frozen_string_literal: true

[1, 4, 8, 14, 19].each do |i|
  Slot.create(user_email: FFaker::Internet.email,
              start_datetime: DateTime.now.beginning_of_day + i.hours,
              end_datetime: DateTime.now.beginning_of_day + (i + 1).hours)
end


