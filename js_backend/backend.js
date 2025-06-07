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

// Route for a simple API endpoint
app.get('/api/data', (req, res) => {
    res.json({
        message: 'Hello from the backend API!',
        timestamp: new Date().toISOString(),
        source: 'JavaScript Backend'
    });
});

// Route for another API endpoint with a dynamic parameter
app.get('/api/users/:id', (req, res) => {
    const userId = req.params.id;
    res.json({
        message: `Details for user ${userId}`,
        userId: userId,
        name: `User ${userId} Name`,
        email: `user${userId}@example.com`
    });
});

// Route for a static asset (e.g., an image placeholder)
app.get('/assets/image.png', (req, res) => {
    res.status(200).send('This is a placeholder for an image.png');
    // res.redirect('https://placehold.co/150x150/000000/FFFFFF?text=Image');
});

// Route to simulate other assets or unmatched paths
app.get('/', (req, res) => {
    res.send('This is a response from /other-path on the backend.');
});


// Start the server and listen on the defined port
app.listen(PORT, () => {
    console.log(`JavaScript Backend server listening at http://localhost:${PORT}`);
});

