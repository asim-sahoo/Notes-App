require('dotenv').config();
const express = require('express');
const app = express();

const Note = require('./models/Note');
const mongoose = require('mongoose');
const dbHOST = process.env.DBHOST;

const bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

mongoose.connect(dbHOST, { useNewUrlParser: true, useUnifiedTopology: true })
    .then(() => {
        console.log('Connected to MongoDB');

        app.get('/', (req, res) => {
            res.json({ message: 'Server Running Successfully' });
        });

        const noteRoutes = require('./routes/Note');
        app.use('/notes', noteRoutes);

        const PORT = process.env.PORT || 5000;
        app.listen(PORT, () => {
            console.log(`Server is running on port ${PORT}`);
        });
    })
    .catch(err => {
        console.error('Database connection error:', err);
    });
