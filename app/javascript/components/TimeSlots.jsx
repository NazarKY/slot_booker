import React, { useEffect } from "react";
import TimeSlot from "./TimeSlot";
import { createConsumer } from '@rails/actioncable';

const TimeSlots = ({
    type, selectedTime, selectedSlot, availableSlots,
    setSlotTimeAndGroup, refreshTimes, setAvailableSlots
  }) => {
  const cable = createConsumer('ws://localhost:3000/cable')

  useEffect(() => {
    createSubscription();
  }, []);

  const createSubscription = () => {
    cable.subscriptions.create(
      { channel: 'SlotsChannel' },
      { received: data => refreshAvailableSlots(data) }
    )
  };

  const refreshAvailableSlots = (data) => {
    refreshTimes();
    setAvailableSlots(data);
  };

  const listItems = availableSlots.map((timeSlot) =>
    <TimeSlot key={parseInt(timeSlot[type])} setSlotTimeAndGroup={setSlotTimeAndGroup} type={type} slot={timeSlot}
              selectedTime={selectedTime} selectedSlot={selectedSlot} />
  );

  return (
    <div className='time-slots-container'>
      <div className="time-slots-title">
        <strong>{type.replace(/([A-Z])/g, ' $1').replace(/^./, function(str){ return str.toUpperCase(); })}</strong>
      </div>
      <div className="time-slots list-group w-auto">
        {listItems}
      </div>
    </div>
  )
};

export default TimeSlots;
