const express = require("express");
const router = express.Router();

// JWT - Authentification token
const bcrypt = require("bcrypt");
const { authenticateToken } = require("../security/jwt");

// SCHEMA
const {
  User,
  Profile,
  Conversation,
  Message,
  Friend,
} = require("../model/schema");

// Repository
const { getFriends } = require("../repository/friendRepository");

// Récupérer les amis
router.get("/friends", authenticateToken, async (req, res) => {
  const userId = req.userId;

  const friends = await getFriends(userId);
  if (!friends) {
    return res.status(404).json({ message: "Aucun ami" });
  }
  res.status(200).json(friends);
});

// Ajouter un ami
router.post("/friends", authenticateToken, async (req, res) => {
  const userId = req.userId;
  const { friendId } = req.body;

  try {
    // Vérifier si l'ami existe
    const existingFriend = await Friend.findOne({
      user1: userId,
      user2: friendId,
    });
    if (existingFriend) {
      return res
        .status(400)
        .json({ message: "Cet utilisateur est déjà votre ami" });
    }

    // Créer une nouvelle relation d'amitié
    await addFriend(userId, friendId);

    res.status(201).json({ message: "Ami ajouté avec succès" });
  } catch (error) {
    console.error("Erreur lors de l'ajout de l'ami :", error);
    res.status(500).json({ message: "Erreur lors de l'ajout de l'ami" });
  }
});

// Mettre à jour le statut d'amitié
router.put("/friends/:friendId", authenticateToken, async (req, res) => {
  const userId = req.userId;
  const friendId = req.params.friendId;
  const { status } = req.body;

  try {
    // Vérifier si l'ami existe et si l'utilisateur est impliqué
    const existingFriend = await Friend.findOne({
      $or: [
        { user1: userId, user2: friendId },
        { user1: friendId, user2: userId },
      ],
    });
    if (!existingFriend) {
      return res.status(404).json({ message: "Ami non trouvé" });
    }

    // Mettre à jour le statut d'amitié
    await updateFriendStatus(userId, friendId, status);

    res.status(200).json({ message: "Statut d'amitié mis à jour avec succès" });
  } catch (error) {
    console.error("Erreur lors de la mise à jour du statut d'amitié :", error);
    res
      .status(500)
      .json({ message: "Erreur lors de la mise à jour du statut d'amitié" });
  }
});

// Exportez le routeur
module.exports = router;
