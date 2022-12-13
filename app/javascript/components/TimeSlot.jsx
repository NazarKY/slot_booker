import React from "react";

const TimeSlot = ({slot, type, setSlotTimeAndGroup, selectedTime, selectedSlot}) => {
  const selectTimeSlot = e => {
    const values = e.target.value.split('-');
    const time = e.target.checked ? values[0] : null;
    const group = e.target.checked ? parseInt(values[1]) : null;
    setSlotTimeAndGroup({time: time, group: group});
  };

  const value = `${slot[type]}-${slot['group']}`
  const notInRange = (type == 'endTime' ? slot[type] <= selectedTime : slot[type] >= selectedTime);
  const inGroup = slot['group'] == selectedSlot['group'] || selectedSlot['group'] == null;
  const isDisabled = notInRange || !inGroup;

  return (
    <li className={`list-group-item d-flex gap-3 ${isDisabled ? 'disabled' : ''}`}>
      <input className="form-check-input flex-shrink-0" type="checkbox"
             checked={`${value}`==`${selectedSlot[type]}-${selectedSlot['group']}`}
             value={value} name={`radio-${type}`}
             onChange={selectTimeSlot} />
      <label className="form-check-label"> <strong>{slot[type]}</strong></label>
    </li>
  )
};

export default TimeSlot;
