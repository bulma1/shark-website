const request = require('supertest');
const app = require('./app'); // Import the Express app

describe('Express App Routes', () => {
    test('GET / should return index.html', async () => {
        const response = await request(app).get('/');
        expect(response.status).toBe(200);
    });

    test('GET /about should return about.html', async () => {
        const response = await request(app).get('/about');
        expect(response.status).toBe(200);
    });

    test('GET /contact should return contact.html', async () => {
        const response = await request(app).get('/contact');
        expect(response.status).toBe(200);
    });

    test('GET /cats/breeds should return breeds.html', async () => {
        const response = await request(app).get('/cats/breeds');
        expect(response.status).toBe(200);
    });

    test('GET /cats/care-guide should return care-guide.html', async () => {
        const response = await request(app).get('/cats/care-guide');
        expect(response.status).toBe(200);
    });

    test('GET /cats/health should return health.html', async () => {
        const response = await request(app).get('/cats/health');
        expect(response.status).toBe(200);
    });

    test('GET /cats/memes should return memes.html', async () => {
        const response = await request(app).get('/cats/memes');
        expect(response.status).toBe(200);
    });

    test('GET /nonexistent should return 404', async () => {
        const response = await request(app).get('/nonexistent');
        expect(response.status).toBe(404);
    });
});
