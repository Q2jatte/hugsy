// SCHEMA
const { User, Profile, Conversation, Message } = require("../model/schema");

// Find messages
async function getMessage(conversationId, userId) {
  try {
    // Vérifier si l'utilisateur fait partie de la conversation
    const conversation = await Conversation.findOne({
      _id: conversationId,
      participants: userId,
    });

    if (!conversation) {
      // Si l'utilisateur n'est pas autorisé, renvoyer un message d'erreur
      throw new Error(
        "Vous n'êtes pas autorisé à accéder à cette conversation."
      );
    }

    const messages = await Message.find({ conversationId: conversationId });

    return messages;
  } catch (error) {
    console.error("Erreur lors de la recherche des conversations :", error);
    throw error;
  }
}

module.exports = { getMessage };
