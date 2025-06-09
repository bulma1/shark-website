const request = require('supertest');
const app = require('./app'); // Import the Express app

describe('Express App Routes', () => {
    test('GET / should return index.html', async () => {
        const response = await request(app).get('/');
        expect(response.status).toBe(200);
    });

    test('GET /sharks should return about.html', async () => {
        const response = await request(app).get('/sharks');
        expect(response.status).toBe(200);
    });

    test('GET /nonexistent should return 404', async () => {
        const response = await request(app).get('/nonexistent');
        expect(response.status).toBe(404);
    });
});
