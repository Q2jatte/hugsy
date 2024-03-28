// SCHEMA
const { Conversation } = require('../model/schema');

// Find conversations
async function getConversation(userId) {

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

module.exports = { getConversation };