const express = require('express');
const app = express();
const router = express.Router();
const path = __dirname + '/views/';
const port = 8080;
const winston = require('winston');

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
  logger.info(`Incoming request: ${req.method} ${req.url}`);
  next();
});
router.use(function (req,res,next) {
  console.log('/' + req.method);
  next();
});
// Router
router.get('/', function(req,res){
  logger.debug('Serving index.html');
  res.sendFile(path + 'index.html');
});

router.get('/sharks', function(req,res){
  logger.debug('Serving sharks.html');
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