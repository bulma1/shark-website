const express = require('express');
const app = express();
const router = express.Router();
const path = __dirname + '/views/';
const port = 8080;
const winston = require('winston');
// List of example users
const exampleUsers = ['Alice', 'Bob', 'Charlie', 'Diana', 'Eve', 'Frank', 'Grace'];
// ✅ Setup Winston Logger
const logger = winston.createLogger({
  level: 'info', // Default level
  format: winston.format.combine(
      winston.format.timestamp(),
      winston.format.printf(({ level, message, timestamp }) => {
        return `${timestamp} [${level.toUpperCase()}] ${message}`;
      })
  ),
  transports: [
    new winston.transports.Console(), // Log to console
    new winston.transports.File({
      filename: 'app.log',
      maxsize: 10000000,
      maxFiles: 10,
      zippedArchive: true
    }) // Save logs to a file
  ]
});

// ✅ Middleware to Log Requests with Different Levels
app.use((req, res, next) => {
  // Use query param if provided, otherwise pick a random user from the list
  const userId = req.query.userId || exampleUsers[Math.floor(Math.random() * exampleUsers.length)];
  req.user = { id: userId }; // Attach user to request object
  logger.info(`Incoming request from user ${req.user.id}: ${req.method} ${req.url}`);
  next();
});
router.use(function (req,res,next) {
  console.log('/' + req.method);
  next();
});
// Router
router.get('/', function(req, res) {
  logger.debug(`User ${req.user.id} requested index.html`);
  res.sendFile(path + 'index.html');
});

router.get('/sharks', function(req, res) {
  logger.debug(`User ${req.user.id} requested sharks.html`);
  res.sendFile(path + 'sharks.html');
});
// Simulating Different Log Levels
app.get('/warn', (req, res) => {
  logger.warn('This is a warning message');
  res.send('Warning logged!');
});

app.get('/error', (req, res) => {
  logger.error('An error occurred!');
  res.status(500).send('Error logged!');
});

app.use(express.static(path));
app.use('/', router);

// Only start the server if this file is run directly
if (require.main === module) {
  app.listen(port, function() {
    logger.info(`App listening on port ${port}!`);
  });
}

module.exports = app;