class SlotsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'slots_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
