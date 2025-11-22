const express = require('express');
const fs = require('fs').promises;
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;
const DATA_FILE = path.join(__dirname, '../data/books.json');

// Middleware
app.use(express.json());
app.use(express.static(path.join(__dirname, '../public')));

// Ensure data directory and file exist
async function ensureDataFile() {
    try {
        const dataDir = path.dirname(DATA_FILE);
        await fs.mkdir(dataDir, { recursive: true });
        
        try {
            await fs.access(DATA_FILE);
        } catch {
            // File doesn't exist, create it with empty array
            await fs.writeFile(DATA_FILE, JSON.stringify([], null, 2), 'utf-8');
            console.log('Created data/books.json');
        }
    } catch (error) {
        console.error('Error ensuring data file:', error);
        throw error;
    }
}

// Read books from JSON file
async function readBooks() {
    try {
        const data = await fs.readFile(DATA_FILE, 'utf-8');
        return JSON.parse(data);
    } catch (error) {
        console.error('Error reading books:', error);
        return [];
    }
}

// Write books to JSON file
async function writeBooks(books) {
    try {
        await fs.writeFile(DATA_FILE, JSON.stringify(books, null, 2), 'utf-8');
    } catch (error) {
        console.error('Error writing books:', error);
        throw error;
    }
}

// API Routes

// GET /api/books - Get all books
app.get('/api/books', async (req, res) => {
    try {
        const books = await readBooks();
        res.json({ success: true, books });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Kitaplar okunamadı' });
    }
});

// POST /api/save - Save a new book
app.post('/api/save', async (req, res) => {
    try {
        const { title, author, publisher, isbn, pageCount, location, tags, note, createdAt } = req.body;
        
        // Validation
        if (!title || title.trim() === '') {
            return res.status(400).json({ 
                success: false, 
                error: 'Başlık gereklidir' 
            });
        }
        
        // Read existing books
        const books = await readBooks();
        
        // Create new book object with unique ID
        const newBook = {
            id: generateId(),
            title: title.trim(),
            author: author || '',
            publisher: publisher || '',
            isbn: isbn || '',
            pageCount: pageCount || 0,
            location: location || '',
            tags: tags || '',
            note: note || '',
            createdAt: createdAt || new Date().toISOString()
        };
        
        // Add to beginning of array
        books.unshift(newBook);
        
        // Save to file
        await writeBooks(books);
        
        res.json({ 
            success: true, 
            message: 'Kitap başarıyla kaydedildi',
            book: newBook
        });
    } catch (error) {
        console.error('Error saving book:', error);
        res.status(500).json({ 
            success: false, 
            error: 'Kitap kaydedilemedi: ' + error.message 
        });
    }
});

// Helper function to generate unique ID
function generateId() {
    return Date.now().toString(36) + Math.random().toString(36).substr(2, 9);
}

// Start server
async function startServer() {
    try {
        await ensureDataFile();
        app.listen(PORT, () => {
            console.log(`\n🚀 Evde Kütüphane web server çalışıyor!`);
            console.log(`📍 URL: http://localhost:${PORT}`);
            console.log(`📁 Veri dosyası: ${DATA_FILE}`);
            console.log(`\nKullanım: Tarayıcıda http://localhost:${PORT} adresini açın\n`);
        });
    } catch (error) {
        console.error('Server başlatılamadı:', error);
        process.exit(1);
    }
}

startServer();
