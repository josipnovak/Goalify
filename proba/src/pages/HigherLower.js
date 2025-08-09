import React, { useEffect, useState } from 'react';

function HigherLower(){
    const [leftPlayer, setLeftPlayer] = useState({});
    const [rightPlayer, setRightPlayer] = useState({});
    const [gameStarted, setGameStarted] = useState(false);
    const [gameEnded, setGameEnded] = useState(false);

    useEffect(() => {
        fetchPlayerOnLoad();
    }, []);

    function fetchPlayerOnLoad(){
        fetch('http://localhost:8080/higherlower/player/')
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
        fetch('http://localhost:8080/higherlower/player/')
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
        fetch(`http://localhost:8080/higherlower/check/${leftPlayer.id}/${rightPlayer.id}/${isHigher}`)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Correct!');
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

    function formatDate(dateString){
        const options = { year: 'numeric', month: 'long', day: 'numeric' };
        return new Date(dateString).toLocaleDateString(undefined, options); 
    }

    return (
        <div>
            <h1>Welcome to the Higher Lower Game!</h1>
            <p>Get ready to test your knowledge!</p>
            {gameEnded ? (
                <div>
                    <h2>Game Over!</h2>
                    <div>
                        <h2>{leftPlayer.name}</h2>
                        <p>Club: {leftPlayer.club}</p>
                        <p>Nationality: {leftPlayer.nationality}</p>
                        <p>Date of Birth: {formatDate(leftPlayer.date_of_birth)}</p>
                    </div>
                    <div>
                        <h2>{rightPlayer.name}</h2>
                        <p>Club: {rightPlayer.club}</p>
                        <p>Nationality: {rightPlayer.nationality}</p>
                        <p>Date of Birth: {formatDate(rightPlayer.date_of_birth)}</p>
                    </div>
                </div>
            ) : !gameStarted ? (
                <div>
                    <div>
                        <h2>{leftPlayer.name}</h2>
                        <p>Club: {leftPlayer.club}</p>
                        <p>Nationality: {leftPlayer.nationality}</p>
                        <p>Date of Birth: {formatDate(leftPlayer.date_of_birth)}</p>
                    </div>
                    <div>
                        <button onClick={fetchPlayerForGame}>Start Game</button>
                    </div>
                </div>
            ) : (
                <div>
                    <div>
                        <h2>{leftPlayer.name}</h2>
                        <p>Club: {leftPlayer.club}</p>
                        <p>Nationality: {leftPlayer.nationality}</p>
                        <p>Date of Birth: {formatDate(leftPlayer.date_of_birth)}</p>
                    </div>
                    <div>
                        <button onClick={() => handleHigherLowerClick(true)}>Higher</button>
                        <button onClick={() => handleHigherLowerClick(false)}>Lower</button>
                    </div>
                    <div>
                        <h2>{rightPlayer.name}</h2>
                        <p>Club: {rightPlayer.club}</p>
                        <p>Nationality: {rightPlayer.nationality}</p>
                    </div>
                </div>
            )}
        </div>
    );
}

export default HigherLower;
