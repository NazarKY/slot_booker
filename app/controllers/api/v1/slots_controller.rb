class Api::V1::SlotsController < ApplicationController
  def index
    day = Date.parse(params[:day])
    available_time_slots = Slot.available_timeslots_with_group(day)

    render json: available_time_slots
  end

  def create
    day = Date.parse(slot_params[:start_datetime])
    slot = Slot.create!(slot_params)
    available_time_slots = Slot.available_timeslots_with_group(day)

    ActionCable.server.broadcast 'slots_channel', available_time_slots if slot
    render json: available_time_slots
  end

  private

  def slot_params
    params.require(:slot).permit(:start_datetime, :end_datetime, :user_email)
  end
end
