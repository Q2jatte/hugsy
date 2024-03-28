// SCHEMA
const { User, Profile, Conversation, Message } = require('../model/schema');

// Find Profile
async function getUserProfile(userId) {
    
    try {
        // Rechercher le profil existant dans la base de données en utilisant l'ID utilisateur
        const existingProfile = await Profile.findOne({ userId: userId });

        // Si un profil existe, le retourner
        if (existingProfile) {
            console.log("profil trouvé ", existingProfile);
            return existingProfile;
        } else {
            console.log("pas de profil");
            // Si aucun profil n'est trouvé, vous pouvez choisir de retourner null ou de lancer une erreur
            return null;
        }
    } catch (error) {
        // Gérer les erreurs potentielles lors de la recherche du profil
        console.error('Erreur lors de la recherche du profil utilisateur :', error);        
    }
}

// Find conversations
async function getUserConversation(userId) {

    try {
        const existingConversations = await Conversation.find({ participants: userId});

        if (existingConversations.length > 0) {            
            return existingConversations;
        } else {
            console.log("pas de conversations");            
            return null;
        }

    } catch (error){
        console.error('Erreur lors de la recherche des conversations :', error);     
    }
}

// Find messages
async function getUserMessage(conversationId, userId) {

    try {
        // Vérifier si l'utilisateur fait partie de la conversation
        const conversation = await Conversation.findOne({ _id: conversationId, participants: userId });

        if (!conversation) {
            // Si l'utilisateur n'est pas autorisé, renvoyer un message d'erreur
            throw new Error('Vous n\'êtes pas autorisé à accéder à cette conversation.');
        }

        const messages = await Message.find({ conversationId: conversationId });

        return messages;

    } catch (error){
        console.error('Erreur lors de la recherche des conversations :', error);
        throw error;     
    }
}

module.exports = { getUserProfile, getUserConversation };