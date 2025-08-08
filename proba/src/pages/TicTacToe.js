import React, { useEffect, useState } from 'react';

function TicTacToe(){
    const [difficulty, setDifficulty] = useState('');
    const [grid, setGrid] = useState(null);
    const [dialogVisible, setDialogVisible] = useState(false);
    const [selectedCell, setSelectedCell] = useState([]);
    const [points, setPoints] = useState({
        X: 0,
        O: 0
    });
    const [players, setPlayers] = useState([]);
    const [searchTerm, setSearchTerm] = useState('');
    const [message, setMessage] = useState('');
    const [answeredCells, setAnsweredCells] = useState({});
    const [firstPlayer, setFirstPlayer] = useState(true);

    useEffect(() => {
        if(!dialogVisible || !searchTerm) return;
        const handler = setTimeout(() => {
            fetchPlayers(searchTerm);
        }, 500);
        return () => clearTimeout(handler);
    }, [searchTerm, dialogVisible]);

    async function fetchPlayers(name) {
        fetch('http://localhost:8080/players/?search=' + name)
            .then(response => response.json())
            .then(data => {
                setPlayers(data);
                console.log('Players fetched:', data);
            })
            .catch(error => console.error('Error fetching players:', error));
    }

    async function fetchGrid(difficulty) {
        fetch('http://localhost:8080/generate/tictactoe/' + difficulty)
            .then(response => response.json())
               .then(data => {
                   setGrid(data);
                   console.log('Grid fetched:', data);
               })
               .catch(error => console.error('Error fetching Tic Tac Toe grid:', error));
       }
   
       function showDialog(nation, teamId) {
           setDialogVisible(true);
           setSelectedCell([nation, teamId]);
       }

        function handlePlayerSelect(playerId) {
            checkPlayer(playerId);
            setSearchTerm('');
            setPlayers([]);
            setSelectedCell([]);
            setDialogVisible(false);
        }

        function checkPlayer(player){
            fetch('http://localhost:8080/tictactoe/check/' + selectedCell[0] + '/' + selectedCell[1] + '/' + player.id)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const key = selectedCell[0] + selectedCell[1];
                        setMessage(`Player ${player.name} is valid for TicTacToe.`);
                        const playerSign = firstPlayer ? ' X' : ' O';
                        const newAnsweredCells = {
                            ...answeredCells,
                            [key]: player.name + playerSign
                        }
                        setAnsweredCells(newAnsweredCells)
                        setPoints(prev => ({
                            ...prev,
                            [playerSign]: (prev[playerSign] || 0) + 10
                        }));
                        setFirstPlayer(!firstPlayer);
                        checkWinner(newAnsweredCells);
                    } else {
                        setMessage(`Player ${player.name} is not valid for TicTacToe.`);
                        setFirstPlayer(!firstPlayer);
                        checkWinner(answeredCells);
                    }
                })
                .catch(error => console.error('Error checking player:', error));
        }

        function checkWinner(newAnsweredCells) {
            if (!grid || !grid.teams || !grid.nationalities) {
                console.error('Invalid grid:', grid);
                return;
            }

            const size = grid.teams.length;
            const board = grid.nationalities.map(nation =>
                grid.teams.map(team => {
                    const val = newAnsweredCells[nation + team.id];
                    if (val && (val.endsWith(' X') || val.endsWith(' O'))) {
                        return val.slice(-1); 
                    }
                    return ' '; 
                })
            );

            console.log('Board state:', board);

            for (let i = 0; i < size; i++) {
                const row = board[i];
                if (row[0] === 'X' || row[0] === 'O') {
                    if (row.every(sign => sign === row[0])) {
                        setMessage(`Player ${row[0]} wins!`);
                        return;
                    }
                }
            }
            for (let j = 0; j < size; j++) {
                const col = board.map(row => row[j]);
                if (col[0] === 'X' || col[0] === 'O') {
                    if (col.every(sign => sign === col[0])) {
                        setMessage(`Player ${col[0]} wins!`);
                        return;
                    }
                }
            }
            const diag1 = board.map((row, i) => row[i]);
            if (diag1[0] === 'X' || diag1[0] === 'O') {
                if (diag1.every(sign => sign === diag1[0])) {
                    setMessage(`Player ${diag1[0]} wins!`);
                    return;
                }
            }
            const diag2 = board.map((row, i) => row[size - 1 - i]);
            if (diag2[0] === 'X' || diag2[0] === 'O') {
                if (diag2.every(sign => sign === diag2[0])) {
                    setMessage(`Player ${diag2[0]} wins!`);
                    return;
                }
            }
            const allFilled = board.flat().every(sign => sign === 'X' || sign === 'O');
            if (allFilled) {
                setMessage("It's a draw!");
                return;
            }
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
               <div>X: {points['X']} O: {points['O']}</div>
               <div>{firstPlayer ? <span>Player 1's turn (X)</span> : <span>Player 2's turn (O)</span>}</div>
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
                            <td key={nation + team.id}>
                                {answeredCells[nation + team.id] ? (
                                    <span>{answeredCells[nation + team.id]}</span> 
                                ) : (
                                    <button onClick={() => showDialog(nation, team.id)}>
                                        Search player
                                    </button>
                                )}
                            </td>
                            ))}
                        </tr>
                        ))}
                    </tbody>
                    </table>
                )}
                {message && <div>{message}</div>}
                {dialogVisible && (
                     <div
                     style={{
                        position: 'fixed',
                        top: 0, left: 0, right: 0, bottom: 0,
                        background: 'rgba(0,0,0,0.3)',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        flexDirection: 'column',
                        zIndex: 1000
                    }}
                        >
                          <h2>Search Player</h2>
                          <input
                            type="text"
                            placeholder="Enter player name"
                            value={searchTerm}
                            onChange={e => setSearchTerm(e.target.value)}
                        />
                          <button onClick={() => {
                            setDialogVisible(false);
                            setSearchTerm('');
                            setSelectedCell([]);
                          }}>Close</button>
                            <div>
                                {players.map(player => (
                                    <div key={player.id}>
                                        <button onClick={() => handlePlayerSelect(player)}>{player.name}</button>
                                    </div>
                                ))}
                            </div>
                        </div>
                    )}
                </div>
            );
}

export default TicTacToe;
