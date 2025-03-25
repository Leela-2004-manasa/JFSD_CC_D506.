import { StrictMode } from "react";
import { BrowserRouter, Route, Routes, Link } from "react-router-dom";
import {createRoot} from "react-dom/client";
import App from "./App";
import LoginForm from "./loginForm";

createRoot(document.getElementById('root')).render(
  <BrowserRouter>
  <Routes>
    <Route path="/" element={<App />} />
    <Route path="*" element={<h1>404 Page not Found</h1> } />
    <Route path="/login" element={<LoginForm/>}/>
  </Routes>
  </BrowserRouter>
);
