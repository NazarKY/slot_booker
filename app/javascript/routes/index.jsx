import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import SlotBooker from "../components/SlotBooker";

export default (
    <Router>
        <Routes>
            <Route path="/" element={<SlotBooker />} />
        </Routes>
    </Router>
);
