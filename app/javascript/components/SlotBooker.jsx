import React, { useState, useEffect } from "react";
import Calendar from 'react-calendar';
import TimeSlots from "./TimeSlots";
import axios from "axios";

const mailFormat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;

const SlotBooker = () => {
  const [selectedSlot, setSelectedSlot] = useState({
    startTime: null,
    endTime: null,
    calendarDate: new Date(),
    userEmail: null,
    emailIsValid: true,
    group: null
  });
  const [responseState, setResponseState] = useState({
    status: null,
    message: null
  });
  const [availableSlots, setAvailableSlots] = useState([]);

  const setStartTimeGroupCallback = (timeGroup) => {
    setSelectedSlot({
      ...selectedSlot,
      startTime: timeGroup.time,
      group: timeGroup.group
    })
  }
  const setEndTimeGroupCallback = (timeGroup) => {
    setSelectedSlot({
      ...selectedSlot,
      endTime: timeGroup.time,
      group: timeGroup.group
    })
  }
  const refreshTimesCallback = () => {
    setSelectedSlot({
      ...selectedSlot,
      startTime: null,
      endTime: null
    })
  }

  useEffect(() => {
    getAvailableSlots(selectedSlot.calendarDate);
  }, []);

  const getAvailableSlots = async (day) => {
    day = day.toLocaleDateString();
    const url = "/api/v1/slots/index";
    try {
      const response = await axios.get(url, { params: { day: day } })
      setAvailableSlots(response.data)
    } catch(error) {
      console.log(error)
    }
  };

  const bookTimeSlot = async () => {
    const url = "/api/v1/slots/create";
    const token = document.querySelector('meta[name="csrf-token"]').content;
    const date = selectedSlot.calendarDate.toLocaleDateString();
    const body = {
      start_datetime: `${date}T${selectedSlot.startTime}`,
      end_datetime: `${date}T${selectedSlot.endTime}`,
      user_email: selectedSlot.userEmail
    };

    try {
      const response = await axios.post(url, { slot: body },
        { headers: { "X-CSRF-Token": token, "Content-Type": "application/json" } }
      );
      setResponseState({ status: response.status, message: 'You have successfully booked the Slot' });
    } catch(error) {
      console.log(error);
    }
  };

  return (
    <div className="container text-center">
      { responseState.status && (
        <div className="alert alert-success alert-dismissible fade show justify-content-center" role="alert">
          {responseState.message}
          <button type="button" className="btn-close" data-bs-dismiss="alert" aria-label="Close" />
        </div>
      )}

      <div className="row">
        <div className="col-md-8">.
          <Calendar value={selectedSlot.calendarDate} className="justify-content-center"
                    onChange={ (date) => {
                      setSelectedSlot({...selectedSlot, calendarDate: date});
                      getAvailableSlots(date);
                    }} />

          <div className="controllers d-grid gap-2">

            <div className="input-group mb-3">
              <span className="input-group-text">@</span>
              <input type="text" className={`form-control ${!selectedSlot.emailIsValid && 'is-invalid'}`}
                     placeholder="Email" aria-label="Email"
                     onChange={(el) => {
                       const value = el.target.value;
                       const isValid = value.match(mailFormat) != null;
                       setSelectedSlot({...selectedSlot, userEmail: value, emailIsValid: isValid})
                     }}/>
            </div>

            <button
              type="button" className="btn btn-outline-primary btn-lg"
              disabled={!(selectedSlot.endTime && selectedSlot.startTime && selectedSlot.userEmail && selectedSlot.emailIsValid)}
              onClick={(event) => bookTimeSlot(event)}>
              Book slot(s)
            </button>
          </div>
        </div>

        <div className="col-6 col-md-2">
          <TimeSlots type={'startTime'} selectedTime={selectedSlot.endTime} selectedSlot={selectedSlot}
                     setSlotTimeAndGroup={setStartTimeGroupCallback} refreshTimes={refreshTimesCallback}
                     availableSlots={availableSlots} setAvailableSlots={setAvailableSlots}/>
        </div>

        <div className="col-6 col-md-2">
          <TimeSlots type={'endTime'} selectedTime={selectedSlot.startTime} selectedSlot={selectedSlot}
                     setSlotTimeAndGroup={setEndTimeGroupCallback} refreshTimes={refreshTimesCallback}
                     availableSlots={availableSlots} setAvailableSlots={setAvailableSlots}/>
        </div>
      </div>
    </div>
  )
};

export default SlotBooker;
