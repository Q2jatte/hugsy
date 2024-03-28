const express = require('express');
const bodyParser = require('body-parser');

// DB ACCESS
const db = require('./db/db');

// JWT - Authentification token
const { generateAccessToken, authenticateToken } = require('./security/jwt');



const mongoose = require('mongoose');
const bcrypt = require('bcrypt');


// Crée une instance d'Express
const app = express();
const PORT = process.env.PORT || 3037;

// Middleware
app.use(bodyParser.json());

// Import des routes
const userRoutes = require('./routes/userRoute');
const conversationRoutes = require('./routes/conversationRoute');
const messageRoutes = require('./routes/messageRoute');
const friendRoutes = require('./routes/friendRoute');

// Utiliser les routes dans l'app
app.use('/api', userRoutes);
app.use('/api', conversationRoutes);
app.use('/api', messageRoutes);
app.use('/api', friendRoutes);

// Écoute le port 3037 pour les requêtes entrantes
app.listen(PORT, () => {
  console.log('Serveur Express en cours d\'écoute sur le port 3037');
});