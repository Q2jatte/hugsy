const mongoose = require('mongoose');


// USER
const userSchema = new mongoose.Schema({
  userName: { type: String, unique: true },
  phoneNumber: String,
  password: String,
  role: [String],
});

const User = mongoose.model('User', userSchema);

// PROFILE
const profileSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    imageUrl: String,
    shortDescription: String,
});

const Profile = mongoose.model('Profile', profileSchema);

// CONVERSATION
const conversationSchema = new mongoose.Schema({
    participants: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
    type: { type: String, enum: ['private', 'group'], required: true },
    createdAt: { type: Date, default: Date.now },
    title: {type: String, required: true },
    // Autres champs de conversation
});

const Conversation = mongoose.model('Conversation', conversationSchema);

// MESSAGE
const messageSchema = new mongoose.Schema({
    conversationId: { type: mongoose.Schema.Types.ObjectId, ref: 'Conversation', required: true },
    senderId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    content: { type: String, required: true },
    timestamp: { type: Date, default: Date.now },
    // Autres champs de message
});

const Message = mongoose.model('Message', messageSchema);

// FRIEND
const friendSchema = new mongoose.Schema({
    user1: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, // ID de l'utilisateur 1
    user2: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, // ID de l'utilisateur 2
    status: { type: String, enum: ['pending', 'accepted', 'rejected'], default: 'pending' }, // Statut de l'amitié    
});

const Friend = mongoose.model('Friend', friendSchema);

module.exports = { User, Profile, Conversation, Message, Friend };