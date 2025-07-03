require ('./tracing');
const express = require('express');
const crypto = require('crypto');
const app = express();
const router = express.Router();
const path = __dirname + '/views/';
const port = 8080;
const winston = require('winston');

// List of example users
const exampleUsers = ['Alice', 'Bob', 'Charlie', 'Diana', 'Eve', 'Frank', 'Grace'];

// ✅ Setup Winston Logger with JSON Format
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
      winston.format.timestamp(),
      winston.format.json() // Use JSON format for structured logs
  ),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({
      filename: 'app.log',
      maxsize: 10000000,
      maxFiles: 10,
      zippedArchive: true
    })
  ]
});

// ✅ Middleware to Log Requests with User Separation
app.use((req, res, next) => {
  const userId = req.query.userId || exampleUsers[crypto.randomInt(0, exampleUsers.length)];
  req.user = { id: userId };
  logger.info({
    message: 'Incoming request',
    user: req.user.id,
    method: req.method,
    url: req.url
  });
  next();
});

router.use((req, res, next) => {
  console.log('/' + req.method);
  next();
});

// Router
router.get('/', (req, res) => {
  logger.debug({
    message: 'User requested index.html',
    user: req.user.id
  });
  res.sendFile(path + 'index.html');
});

router.get('/about', (req, res) => {
  logger.debug({
    message: 'User requested about.html',
    user: req.user.id
  });
  res.sendFile(path + 'about.html');
});

router.get('/contact', (req, res) => {
  logger.debug({
    message: 'User requested contact.html',
    user: req.user.id
  });
  res.sendFile(path + 'contact.html');
});

router.get('/cats/breeds', (req, res) => {
  logger.debug({
    message: 'User requested breeds.html',
    user: req.user.id
  });
  res.sendFile(path + 'cats/breeds.html');
});

router.get('/cats/care-guide', (req, res) => {
  logger.debug({
    message: 'User requested care-guide.html',
    user: req.user.id
  });
  res.sendFile(path + 'cats/care-guide.html');
});

router.get('/cats/health', (req, res) => {
  logger.debug({
    message: 'User requested health.html',
    user: req.user.id
  });
  res.sendFile(path + 'cats/health.html');
});

router.get('/cats/memes', (req, res) => {
  logger.debug({
    message: 'User requested memes.html',
    user: req.user.id
  });
  res.sendFile(path + 'cats/memes.html');
});

// Simulating Different Log Levels
app.get('/warn', (req, res) => {
  logger.warn({ message: 'This is a warning message', user: req.user.id });
  res.send('Warning logged!');
});

app.get('/error', (req, res) => {
  logger.error({ message: 'An error occurred!', user: req.user.id });
  res.status(500).send('Error logged!');
});

// ✅ New Endpoint to Retrieve Logs for a Specific User
const fs = require('fs');
const readline = require('readline');

app.get('/logs/:userId', async (req, res) => {
  const userId = req.params.userId;
  const logs = [];

  const fileStream = fs.create_pipe_stream('app.log');
  const rl = readline.createInterface({
    input: fileStream,
    crlfDelay: Infinity
  });

  for await (const line of rl) {
    try {
      const logEntry = JSON.parse(line);
      if (logEntry.user === userId) {
        logs.push(logEntry);
      }
    } catch (err) {
      console.error('Error parsing log line:', err);
    }
  }

  res.json(logs);
});

app.use(express.static(path));
app.use('/', router);

if (require.main === module) {
  app.listen(port, () => {
    logger.info({ message: `App listening on port ${port}!` });
  });
}

module.exports = app;