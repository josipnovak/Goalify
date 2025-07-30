import React from 'react';
import { Button } from 'react-native-web';
import './App.css';
import { useEffect, useState } from 'react';
import { Route, useNavigate } from 'react-router-dom';
import Trivia from './pages/Trivia';
  

function App() {
 
  const navigate = useNavigate(); 
  return (
    <button
      onClick={() => navigate('/trivia')}
      style={{ backgroundColor: '#841584', color: 'white', padding: '10px 20px', border: 'none', borderRadius: '5px' }}
      aria-label="Learn more about this purple button"
    >     
      Welcome to the Trivia Quiz App!
    </button>
  );
}

export default App;