# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Slot, type: :model do
  TIMESLOTS_TOTAL_SIZE = 24

  subject do
    FactoryBot.create(:slot,
                      start_datetime: DateTime.parse('01/01/2100T01:00'),
                      end_datetime: DateTime.parse('01/01/2100T21:00'))
  end

  it 'is not valid with no attributes' do
    subject.user_email = 'nil'
    subject.start_datetime = 'nil'
    subject.end_datetime = 'nil'
    expect(subject).to be_invalid
  end

  context 'when was just created' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is by default with in_progress status' do
      expect(subject.in_progress?).to be_truthy
    end

    it 'is by default with uuid when saved' do
      subject.save
      expect(subject.uuid.present?).to be_truthy
    end
  end

  context 'when status was changed' do
    it 'is with completed status' do
      subject.status = :completed
      expect(subject.completed?).to be_truthy
    end

    it 'is with completed status' do
      subject.status = :cancelled
      expect(subject.cancelled?).to be_truthy
    end
  end

  describe '#start_time' do
    it 'return correct time' do
      expect(subject.start_time).to eq('01:00')
    end
  end

  describe '#end_time' do
    it 'return correct time' do
      expect(subject.end_time).to eq('21:00')
    end

    it 'return correct time when midnight' do
      subject.end_datetime = DateTime.parse('01/01/2100T00:00')
      expect(subject.end_time).to eq('24:00')
    end
  end

  describe '#booked_timeslots' do
    before do
      FactoryBot.reload
      FactoryBot.create_list(:slot, 5)
    end

    it 'return correct count of timeslots' do
      expect(Slot.booked_timeslots(Date.today).size).to eq 5
    end

    it 'return correct format of timeslot' do
      sample_slot = Slot.booked_timeslots(Date.today).sample
      expect(sample_slot.keys).to include(:startTime, :endTime)
      expect(sample_slot[:startTime] < sample_slot[:endTime]).to be_truthy
    end
  end

  describe '#available_timeslots' do
    before do
      FactoryBot.reload
      FactoryBot.create_list(:slot, 5)
    end

    it 'return correct count of timeslots' do
      slots_size = Slot.available_timeslots(Date.today).size
      expect(TIMESLOTS_TOTAL_SIZE - slots_size).to eq 5
    end

    it 'return correct format of timeslot' do
      sample_slot = Slot.available_timeslots(Date.today).sample
      expect(sample_slot.keys).to include(:startTime, :endTime)
      expect(sample_slot[:startTime] < sample_slot[:endTime]).to be_truthy
    end
  end

  describe '#available_timeslots_with_group' do
    before do
      FactoryBot.reload
      FactoryBot.create_list(:slot, 5)
    end

    it 'return correct count of timeslots' do
      slots_size = Slot.available_timeslots_with_group(Date.today).size
      expect(TIMESLOTS_TOTAL_SIZE - slots_size).to eq 5
    end

    it 'return correct format of timeslot' do
      sample_slot = Slot.available_timeslots_with_group(Date.today).sample
      expect(sample_slot.keys).to include(:startTime, :endTime, :group)
      expect(sample_slot[:startTime] < sample_slot[:endTime]).to be_truthy
    end
  end
end
