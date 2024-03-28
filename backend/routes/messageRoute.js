const express = require("express");
const router = express.Router();

// JWT - Authentification token
const bcrypt = require("bcrypt");
const { authenticateToken } = require("../security/jwt");

// SCHEMA
const { User, Profile, Conversation, Message } = require("../model/schema");

// Repository
const { getMessage } = require("../repository/messageRepository");

// Récupérer des messages
router.get("/messages", authenticateToken, async (req, res) => {
  const userId = req.userId;
  try {
    const message = await getUserMessage(userId);
    if (!message) {
      return res.status(404).json({ message: "Aucun message" });
    }
    res.status(200).json(message);
  } catch (error) {
    res.status(403).json({ message: error.message });
  }
});

// Ajouter un message à une conversation
router.post(
  "/conversations/:conversationId/message",
  authenticateToken,
  async (req, res) => {
    const userId = req.userId;
    const conversationId = req.params.conversationId;
    const { content } = req.body;

    try {
      // Ajouter le message à la conversation
      const newMessage = await addMessage(conversationId, userId, content);

      res.status(201).json(newMessage);
    } catch (error) {
      console.error(
        "Erreur lors de l'ajout du message à la conversation :",
        error
      );
      res
        .status(500)
        .json({
          message: "Erreur lors de l'ajout du message à la conversation",
        });
    }
  }
);

// Supprimer un message
router.delete(
  "/conversations/:conversationId/message/:messageId",
  authenticateToken,
  async (req, res) => {
    const userId = req.userId;
    const conversationId = req.params.conversationId;
    const messageId = req.params.messageId;

    try {
      // Vérifier si l'utilisateur est l'auteur du message
      const message = await Message.findOne({
        _id: messageId,
        senderId: userId,
      });
      if (!message) {
        return res
          .status(403)
          .json({ message: "Vous n'êtes pas autorisé à supprimer ce message" });
      }

      // Supprimer le message
      await deleteMessage(conversationId, messageId);

      res.status(200).json({ message: "Message supprimé avec succès" });
    } catch (error) {
      console.error("Erreur lors de la suppression du message :", error);
      res
        .status(500)
        .json({ message: "Erreur lors de la suppression du message" });
    }
  }
);

// Exportez le routeur
module.exports = router;
