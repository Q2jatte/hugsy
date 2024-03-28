const express = require('express');
const bodyParser = require('body-parser');
const db = require('./db/db'); // Importer le fichier de connexion
const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

// Crée une instance d'Express
const app = express();
const PORT = process.env.PORT || 3037;

// Middleware
app.use(bodyParser.json());

// Schema
const { Schema } = mongoose;

const userSchema = new Schema({
  userName: String,
  phoneNumber: String,
  password: String
});

const User = mongoose.model('User', userSchema);

// Définit une route GET pour la racine de l'application
app.get('/', (req, res) => {
  res.send('Welcome to Hugsy REST API');
});

app.post('/api/check-username', async (req, res) => {  
  try {
    const { userName } = req.body;    
    // Recherche dans la base de données si le nom d'utilisateur existe déjà
    const existingUser = await User.findOne({ userName });

    if (existingUser) {
      // Si le nom d'utilisateur existe déjà, retourner une réponse indiquant qu'il est déjà utilisé
      res.status(200).json({ "isUserNameAvailable": false });
    } else {
      // Si le nom d'utilisateur n'existe pas encore, retourner une réponse indiquant qu'il est disponible
      res.status(200).json({ "isUserNameAvailable": true });
    }

  } catch (error) {
    console.error('Erreur lors de la recherche du nom d\'utilisateur :', error);
    res.status(500).json({ message: 'Erreur lors de la recherche du nom d\'utilisateur' });
  }
});

app.post('/api/check-phonenumber', async (req, res) => {  
  try {
    const { phoneNumber } = req.body;    
    // Recherche dans la base de données si le numéro existe déjà
    const existingPhoneNumber = await User.findOne({ phoneNumber });

    if (existingPhoneNumber) {
      // Si le numéro existe déjà, retourner une réponse indiquant qu'il est déjà utilisé
      res.status(200).json({ "isPhoneNumberAvailable": false });
    } else {
      // Si le nom d'utilisateur n'existe pas encore, retourner une réponse indiquant qu'il est disponible
      res.status(200).json({ "isPhoneNumberAvailable": true });
    }

  } catch (error) {
    console.error('Erreur lors de la recherche du numéro :', error);
    res.status(500).json({ message: 'Erreur lors de la recherche du numéro' });
  }
});

app.post('/api/users/create', async (req, res) => { 
  console.log("Body : ", req.body);
  const { userName, phoneNumber, password } = req.body;
  try {

    // Vérifier si le userName existe déjà
    const existingUser = await User.findOne({ userName });
    if (existingUser) {
      return res.status(400).json({ message: "Le nom d'utilisateur existe déjà." });
    }

    // Vérifier si le phoneNumber existe déjà
    const existingPhoneNumber = await User.findOne({ phoneNumber });
    if (existingPhoneNumber) {
      return res.status(400).json({ message: "Le numéro de téléphone existe déjà." });
    }
    // Hasher le mot de passe
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Créer un nouvel utilisateur avec le mot de passe hashé
    const newUser = new User({
        userName,
        phoneNumber,
        password: hashedPassword
    });

    // Enregistrer le nouvel utilisateur dans la base de données
    await newUser.save();

    // Réponse
    res.status(200).json({ "isUserCreated": true });

  } catch (error) {
    console.error('Erreur lors de l\'enregistrement de l\'utilisateur :', error);
    res.status(500).send('Erreur lors de l\'enregistrement de l\'utilisateur');
  }  
});



// Écoute le port 3037 pour les requêtes entrantes
app.listen(3037, () => {
  console.log('Serveur Express en cours d\'écoute sur le port 3037');
});