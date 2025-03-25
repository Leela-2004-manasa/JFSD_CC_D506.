import { useState } from 'react'
import {useNavigate} from 'react-router-dom';
import './App.css'
import Login from './loginForm'

function App() {


  const navigate = useNavigate();

  return (
    <>
    <h1>Home Page</h1>

    <button onClick={() => navigate('/login')}>Login</button> 


     </> 
  )
}

export default App
