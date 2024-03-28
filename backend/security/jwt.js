const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');

// get config vars
dotenv.config();

// access config var
process.env.TOKEN_SECRET;

// Generate Token
function generateAccessToken(userId) {
    return jwt.sign(userId, process.env.TOKEN_SECRET, { expiresIn: '1h' });
}

// Renew Token
function renewAccessToken(oldToken) {
    try {
        // Vérifier et décoder l'ancien token pour obtenir les informations utilisateur
        const decodedToken = jwt.verify(oldToken, process.env.TOKEN_SECRET);

        // Générer un nouveau token avec les mêmes informations utilisateur et une nouvelle date d'expiration
        const newToken = jwt.sign(decodedToken, process.env.TOKEN_SECRET, { expiresIn: '1h' });        
        return newToken;
    } catch (error) {
        console.error('Erreur lors du renouvellement du token :', error);
        throw error; // Lancer l'erreur pour être gérée par le code appelant
    }
}

// Authenticate with token
async function authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization']
    const token = authHeader && authHeader.split(' ')[1]

    if (token == null) return res.sendStatus(401)    

    jwt.verify(token, process.env.TOKEN_SECRET, (err, user) => {        

        if (err) {
            if (err.name === 'TokenExpiredError') {
                // Le token a expiré, on le renouvelle
                const newToken = renewAccessToken(oldToken);
                return res.status(401).json({ message: 'Renouvellement du token', token: newToken });
            } else {
                // Le token est invalide pour une autre raison
                return res.status(401).json({ message: 'Token invalide.' });
            }
        }        
        req.userId = user.userId;
        next();        
    })  
}

module.exports = { generateAccessToken, authenticateToken };