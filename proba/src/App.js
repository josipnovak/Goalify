import React from 'react';
import { Button } from 'react-native-web';
import './App.css';
import { useEffect, useState } from 'react';
import { Route, useNavigate } from 'react-router-dom';
import Trivia from './pages/Trivia';
  

function App() {
 
  const navigate = useNavigate(); 
  return (
    <div className="App">
   <Button
      onPress={() => navigate('/trivia')}
      title = "Trivia Game!"
      color = "#841584"
      aria-label="Learn more about this purple button"
    />
    <Button
      onPress={() => navigate('/tictactoe')}
      title = "TicTacToe Game!"
      color = "#841584"
      aria-label="Learn more about this purple button"
    />
    <Button
      onPress={() => navigate('/higherlower')}
      title = "Higher Lower Game!"
      color = "#841584"
      aria-label="Learn more about this purple button"
    />
    </div>
  );
}

export default App;