//node backend.js

const express = require('express');
const app = express();
const PORT = 3000;

app.use(express.json());

app.post('/api/submit', (req, res) => {
    res.status(200).json({
        status: 'success',
        receivedData: req.body,
        message: 'Data received successfully!'
    });
});

app.get('/api/users/:id', (req, res) => {
    const userId = req.params.id;
    res.json({
        message: `Details for user ${userId}`,
        userId: userId,
        name: `User ${userId} Name`,
        email: `user${userId}@example.com`
    });
});


app.listen(PORT, () => {
    console.log(`JavaScript Backend server listening at http://localhost:${PORT}`);
});

