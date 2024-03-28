const express = require("express");
const router = express.Router();

// JWT - Authentification token
const bcrypt = require("bcrypt");
const { generateAccessToken, authenticateToken } = require("../security/jwt");

// SCHEMA
const { User, Profile, Conversation, Message } = require("../model/schema");

// Repository
const {
  getUserProfile,
  getUserConversation,
} = require("../repository/userRepository");

// GET

// Tester l'authentification
router.get("/authenticated", authenticateToken, (req, res) => {
  res.status(200).json({ isAuthenticated: true });
});

// Récupérer le profil
router.get("/users/profile", authenticateToken, async (req, res) => {
  const userId = req.userId; // Récupérer l'ID utilisateur à partir de req.userId

  // Utiliser l'ID utilisateur pour récupérer le profil de l'utilisateur depuis la base de données
  const userProfile = await getUserProfile(userId);
  if (!userProfile) {
    return res.status(404).json({ message: "Profil utilisateur non trouvé" });
  }
  res.status(200).json(userProfile);
});

// POST
router.post("/check-username", async (req, res) => {
  try {
    const { userName } = req.body;
    // Recherche dans la base de données si le nom d'utilisateur existe déjà
    const existingUser = await User.findOne({ userName });

    if (existingUser) {
      // Si le nom d'utilisateur existe déjà, retourner une réponse indiquant qu'il est déjà utilisé
      res.status(200).json({ isUserNameAvailable: false });
    } else {
      // Si le nom d'utilisateur n'existe pas encore, retourner une réponse indiquant qu'il est disponible
      res.status(200).json({ isUserNameAvailable: true });
    }
  } catch (error) {
    console.error("Erreur lors de la recherche du nom d'utilisateur :", error);
    res
      .status(500)
      .json({ message: "Erreur lors de la recherche du nom d'utilisateur" });
  }
});

router.post("/check-phonenumber", async (req, res) => {
  try {
    const { phoneNumber } = req.body;
    // Recherche dans la base de données si le numéro existe déjà
    const existingPhoneNumber = await User.findOne({ phoneNumber });

    if (existingPhoneNumber) {
      // Si le numéro existe déjà, retourner une réponse indiquant qu'il est déjà utilisé
      res.status(200).json({ isPhoneNumberAvailable: false });
    } else {
      // Si le nom d'utilisateur n'existe pas encore, retourner une réponse indiquant qu'il est disponible
      res.status(200).json({ isPhoneNumberAvailable: true });
    }
  } catch (error) {
    console.error("Erreur lors de la recherche du numéro :", error);
    res.status(500).json({ message: "Erreur lors de la recherche du numéro" });
  }
});

router.post("/users/create", async (req, res) => {
  console.log("Body : ", req.body);
  const { userName, phoneNumber, password } = req.body;
  try {
    // Vérifier si le userName existe déjà
    const existingUser = await User.findOne({ userName });
    if (existingUser) {
      return res
        .status(400)
        .json({ message: "Le nom d'utilisateur existe déjà." });
    }

    // Vérifier si le phoneNumber existe déjà
    const existingPhoneNumber = await User.findOne({ phoneNumber });
    if (existingPhoneNumber) {
      return res
        .status(400)
        .json({ message: "Le numéro de téléphone existe déjà." });
    }
    // Hasher le mot de passe
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Créer un nouvel utilisateur avec le mot de passe hashé et role user
    const newUser = new User({
      userName,
      phoneNumber,
      password: hashedPassword,
      role: ["role_user"],
    });

    // Enregistrer le nouvel utilisateur dans la base de données
    await newUser.save();

    // Création du profil
    const userId = newUser._id;
    const userProfile = new Profile({
      userId: userId,
      imageUrl: "",
      shortDescription: "So happy 🥳 !!!",
    });

    // Enregistrer le profil dans la base de données
    await userProfile.save();

    // Retourner un token
    const token = generateAccessToken({ userId: newUser._id });
    res.status(200).json({ token: token });
    //res.status(200).json({ "isUserCreated": true });
  } catch (error) {
    console.error("Erreur lors de l'enregistrement de l'utilisateur :", error);
    res.status(500).send("Erreur lors de l'enregistrement de l'utilisateur");
  }
});

// Exportez le routeur
module.exports = router;
