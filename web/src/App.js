import './App.css';
import { useNavigate } from 'react-router-dom';
  

function App() {
 
  const navigate = useNavigate(); 
  return (
    <div className="App">
      <h1 className="App-title">Football Games Hub</h1>
      <button
        className="App-button"
        onClick={() => navigate('/trivia')}
        aria-label="Navigate to Trivia Game"
      >
        Trivia Game
      </button>
      <button
        className="App-button"
        onClick={() => navigate('/tictactoe')}
        aria-label="Navigate to TicTacToe Game"
      >
        TicTacToe Game
      </button>
      <button
        className="App-button"
        onClick={() => navigate('/higherlower')}
        aria-label="Navigate to Higher Lower Game"
      >
        Higher Lower Game
      </button>
    </div>
  );
}

export default App;