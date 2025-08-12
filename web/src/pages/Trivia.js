import React, { useEffect, useState } from 'react';
import './Trivia.css'
function Trivia(){
    const [question, setQuestion] = useState([]);
    const [result, setResult] = useState(false);
    const [score, setScore] = useState(0);

    async function fetchQuestion() {
        fetch('http://localhost:8080/questions/random')
            .then(response => response.json())
            .then(setQuestion)
            .catch(error => console.error('Error fetching trivia questions:', error));
    }

    useEffect(() => {
        fetchQuestion();
    }, []);


    const handleSubmit = async (option) => {
        if (!question.id) return;
        try {
            const res = await fetch(`http://localhost:8080/check_question/${question.id}/${option}`);
            const data = await res.json();
            setResult(data);
            if(data.correct) {
                setScore(score + 1);
                setTimeout(() => {
                    setResult(null);
                    fetchQuestion();
                }, 2000);
            }
            else {
                setScore(0);
                setTimeout(() => {
                    setResult(false);
                    fetchQuestion();
                }, 2000);
            }
        } catch (err) {
            setResult({ error: 'Failed to check answer.' });
        }
    };

    return (
        <div className="trivia-container">
            <h1 className="trivia-title">Football Trivia</h1>
            <div className="score-board">Score: {score}</div>
            {question.question_text && (
                    <div>{question.question_text}<br></br>
                        <button type="button" className="option-btn" onClick={() => handleSubmit('A')}>{question.option_a}</button>
                        <button type="button" className="option-btn" onClick={() => handleSubmit('B')}>{question.option_b}</button>
                        <button type="button" className="option-btn" onClick={() => handleSubmit('C')}>{question.option_c}</button>
                        <button type="button" className="option-btn" onClick={() => handleSubmit('D')}>{question.option_d}</button>
                    </div>
            )}
            {result && !result.error && (
            <div className="result-message">
            {result.correct ? '✅ Correct!' : '❌ Wrong!'}
            </div>
        )}
        </div>
    );
}

export default Trivia;
