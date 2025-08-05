import React, { useEffect, useState } from 'react';

function TicTacToe(){
   const [difficulty, setDifficulty] = useState('');
   const [grid, setGrid] = useState(null);
   
       async function fetchGrid(difficulty) {
           fetch('http://localhost:8080/generate/tictactoe/' + difficulty)
               .then(response => response.json())
               .then(data => {
                   setGrid(data);
                   console.log('Grid fetched:', data);
               })
               .catch(error => console.error('Error fetching Tic Tac Toe grid:', error));
       }
   
   
       return (
           <div>
               <h1>Welcome to the Trivia Quiz!</h1>
               <p>Get ready to test your knowledge!</p>
               <div onClick={(e) => {
                   setDifficulty(e.target.value);
                   fetchGrid(e.target.value);
                }} style={{ display: difficulty ? 'none' : 'block' }}>
                   <div>Select difficulty:</div>
                   <button value="easy">Easy</button>
                   <button value="medium">Medium</button>
                   <button value="hard">Hard</button>
               </div>
               <div>{difficulty}</div>
               {grid && (
                <table border="1" cellPadding="8" style={{ marginTop: 20, borderCollapse: 'collapse' }}>
                    <tbody>
                        <tr>
                        <td></td>
                        {grid.teams.map(team => (
                            <td key={team.id}>
                            <img src={team.logo_url} alt={team.name} width={32} height={32} title={team.name} /><br />
                            </td>
                        ))}
                        </tr>
                        {grid.nationalities.map(nation => (
                        <tr key={nation}>
                            <td>{nation}</td>
                            {grid.teams.map(team => (
                            <td key={team.id + nation}></td>
                            ))}
                        </tr>
                        ))}
                    </tbody>
                    </table>
                )}
           </div>
       );
}

export default TicTacToe;
