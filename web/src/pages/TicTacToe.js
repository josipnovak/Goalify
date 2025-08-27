import React, { useEffect, useState } from 'react';
import './TicTacToe.css';
import { baseUrl } from '../App';

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
        fetch(`${baseUrl}/players/?search=` + name)
            .then(response => response.json())
            .then(data => {
                setPlayers(data);
                console.log('Players fetched:', data);
            })
            .catch(error => console.error('Error fetching players:', error));
    }

    async function fetchGrid(difficulty) {
        fetch(`${baseUrl}/generate/tictactoe/` + difficulty)
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
            fetch(`${baseUrl}/tictactoe/check/${selectedCell[0]}/${selectedCell[1]}/${player.id}`)
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
        <div className="tictactoe-container">
            <div className="tictactoe-title">Tic Tac Toe</div>

            <div className="tictactoe-scoreboard">
            <span>X: {points.X} &nbsp; | &nbsp; O: {points.O}</span>
            </div>

            {!difficulty && (
            <div>
                <button
                className="tictactoe-btn"
                onClick={() => { setDifficulty('easy'); fetchGrid('easy'); }}>
                Easy
                </button>
                <button
                className="tictactoe-btn"
                onClick={() => { setDifficulty('medium'); fetchGrid('medium'); }}>
                Medium
                </button>
                <button
                className="tictactoe-btn"
                onClick={() => { setDifficulty('hard'); fetchGrid('hard'); }}>
                Hard
                </button>
            </div>
            )}

            {difficulty && grid && (
            <div className="tictactoe-board">
                <div className="tictactoe-row">
                    <div className="tictactoe-cell disabled"></div> 

                    {grid.teams.map(team => (
                    <div key={team.id} className="tictactoe-cell header">
                        <img src={team.logo_url} alt={team.name} title={team.name} />
                    </div>
                    ))}
                </div>

                {grid.nationalities.map(nation => (
                    <div className="tictactoe-row" key={nation}>
                    <div className="tictactoe-cell header">{nation}</div>
                    {grid.teams.map(team => {
                        const key = nation + team.id;
                        return (
                        <div
                            key={team.id}
                            className={`tictactoe-cell ${answeredCells[key] ? "" : ""}`}
                            onClick={() => !answeredCells[key] && showDialog(nation, team.id)}
                        >
                            {answeredCells[key] || ""}
                        </div>
                        );
                    })}
                    </div>
                ))}
                </div>
            )}

            {message && (
            <div className={
                "tictactoe-message" +
                (message.includes("wins") ? " win" : "") +
                (message.includes("not valid") ? " error" : "")
            }>
                {message}
            </div>
            )}

            {dialogVisible && (
            <div className="tictactoe-dialog">
                <div style={{ marginBottom: 10 }}>
                <b>Search player for cell</b>
                </div>
                <input
                type="text"
                placeholder="Type player name"
                value={searchTerm}
                onChange={e => setSearchTerm(e.target.value)}
                />
                <div className="player-list">
                {players.length === 0 && searchTerm && <div style={{ fontSize:'1em', color:'#ffeb3b'}}>No players found</div>}
                {players.map(player => (
                    <button
                    className="player-list-item"
                    key={player.id}
                    onClick={() => handlePlayerSelect(player)}
                    >
                    {player.name} - {player.club}
                    </button>
                ))}
                </div>
                <button className="tictactoe-btn" onClick={() => setDialogVisible(false)}>Cancel</button>
            </div>
            )}
        </div>
        );
}

export default TicTacToe;
