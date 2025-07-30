import { useEffect, useState } from 'react';

function App() {
  const [users, setUsers] = useState([]);

  useEffect(() => {
    fetch('http://localhost:8080/questions')
      .then(res => res.json())
      .then(data => setUsers(data));
  }, []);

  return (
    <div>
      <h1>Questions:</h1>
      <ul>
        {users.map(u => <li key={u.id}>{u.question_text}</li>)}
      </ul>
    </div>
  );
}

export default App;