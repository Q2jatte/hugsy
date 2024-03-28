const express = require("express");
const router = express.Router();

// JWT - Authentification token
const bcrypt = require("bcrypt");
const { authenticateToken } = require("../security/jwt");

// SCHEMA
const { User, Profile, Conversation, Message } = require("../model/schema");

// Repository
const { getConversation } = require("../repository/conversationRepository");

// Récupérer les conversations
router.get("/conversations", authenticateToken, async (req, res) => {
  const userId = req.userId;

  const conversation = await getConversation(userId);
  if (!conversation) {
    return res.status(404).json({ message: "Aucune conversation" });
  }
  res.status(200).json(conversation);
});

// Créer une nouvelle conversation
router.post("/conversations", authenticateToken, async (req, res) => {
  const userId = req.userId;
  const { title, participants } = req.body; // Ajouter le titre de la conversation

  try {
    // Vérifier si les participants sont fournis et au moins un participant autre que l'utilisateur actuel
    if (
      !participants ||
      participants.length === 0 ||
      !participants.includes(userId)
    ) {
      return res
        .status(400)
        .json({ message: "Participants invalides pour la conversation" });
    }

    // Créer une nouvelle conversation avec le titre
    const newConversation = await createConversation(title, participants);

    res.status(201).json(newConversation);
  } catch (error) {
    console.error("Erreur lors de la création de la conversation :", error);
    res
      .status(500)
      .json({ message: "Erreur lors de la création de la conversation" });
  }
});

// Supprimer une conversation
router.delete(
  "/conversations/:conversationId",
  authenticateToken,
  async (req, res) => {
    const userId = req.userId;
    const conversationId = req.params.conversationId;

    try {
      // Vérifier si l'utilisateur est autorisé à supprimer la conversation
      const conversation = await Conversation.findOne({
        _id: conversationId,
        participants: userId,
      });
      if (!conversation) {
        return res.status(403).json({
          message: "Vous n'êtes pas autorisé à supprimer cette conversation",
        });
      }

      // Supprimer la conversation
      await deleteConversation(conversationId);

      res.status(200).json({ message: "Conversation supprimée avec succès" });
    } catch (error) {
      console.error(
        "Erreur lors de la suppression de la conversation :",
        error
      );
      res
        .status(500)
        .json({ message: "Erreur lors de la suppression de la conversation" });
    }
  }
);

// Exportez le routeur
module.exports = router;
