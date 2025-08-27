import React, { useEffect, useState } from 'react';
import './HigherLower.css';
import { baseUrl } from '../App';

function HigherLower(){
    const [leftPlayer, setLeftPlayer] = useState({});
    const [rightPlayer, setRightPlayer] = useState({});
    const [gameStarted, setGameStarted] = useState(false);
    const [gameEnded, setGameEnded] = useState(false);

    useEffect(() => {
        fetchPlayerOnLoad();
    }, []);

    function fetchPlayerOnLoad(){
        fetch(`${baseUrl}/higherlower/player/`)
            .then(response => response.json())
            .then(data => {
                if (data) {
                    setLeftPlayer(data);
                }
            })
            .catch(err => {
                console.error('Error fetching player:', err);
            });
    }

    function fetchPlayerForGame(){
        fetch(`${baseUrl}/higherlower/player/`)
            .then(response => response.json())
            .then(data => {
                if (data) {
                    setRightPlayer(data);
                    setGameStarted(true);
                }
            })
            .catch(err => {
                console.error('Error fetching player:', err);
            });
    }

    function handleHigherLowerClick(isHigher){
        fetch(`${baseUrl}/higherlower/check/${leftPlayer.id}/${rightPlayer.id}/${isHigher}`)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    setLeftPlayer(rightPlayer);
                    setRightPlayer({});
                    fetchPlayerForGame();
                } else {
                    setGameEnded(true);
                }
            })
            .catch(err => {
                console.error('Error checking answer:', err);
            });
    }

    function calculateAge(dateString){
        const birthDate = new Date(dateString);
        const ageDiff = Date.now() - birthDate.getTime();
        const ageDate = new Date(ageDiff);
        return Math.abs(ageDate.getUTCFullYear() - 1970);
    }

    return (
    <div className="higherlower-container">
      <h1 className="higherlower-title">Higher or Lower - Football Edition</h1>

      {!gameStarted && !gameEnded && (
        <button className="higherlower-btn" onClick={fetchPlayerForGame}>
          Start Game
        </button>
      )}

      {gameStarted && !gameEnded && (
        <div>
          <div className="player-card">
            <h2>{leftPlayer.name}</h2>
            <p>Club: {leftPlayer.club}</p>
            <p>Nationality: {leftPlayer.nationality}</p>
            <p>Age: {calculateAge(leftPlayer.date_of_birth)}</p>
            <p>Market Value: {leftPlayer.market_value}</p>
          </div>

          <div>
            <button className="higherlower-btn" onClick={() => handleHigherLowerClick(true)}>Higher</button>
            <button className="higherlower-btn" onClick={() => handleHigherLowerClick(false)}>Lower</button>
          </div>

          {rightPlayer.name && (
            <div className="player-card">
              <h2>{rightPlayer.name}</h2>
              <p>Club: {rightPlayer.club}</p>
              <p>Nationality: {rightPlayer.nationality}</p>
              <p>Age: {calculateAge(rightPlayer.date_of_birth)}</p>
            </div>
          )}
        </div>
      )}

      {gameEnded && (
        <div className="game-over">
          <p>Game Over! Try Again?</p>
          <button className="higherlower-btn" onClick={() => window.location.reload()}>
            Restart
          </button>
        </div>
      )}
    </div>
  );
}

export default HigherLower;
