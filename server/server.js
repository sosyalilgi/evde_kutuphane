// server.js - Express server for Evde Kütüphane web interface

const express = require('express');
const fs = require('fs').promises;
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Path to books.json file
const BOOKS_FILE = path.join(__dirname, '../data/books.json');

// Middleware
app.use(express.json());
app.use(express.static(path.join(__dirname, '../public')));

// Ensure data directory and books.json exist
async function ensureDataFile() {
    try {
        await fs.access(BOOKS_FILE);
    } catch (error) {
        // File doesn't exist, create it with empty array
        const dataDir = path.dirname(BOOKS_FILE);
        try {
            await fs.access(dataDir);
        } catch {
            await fs.mkdir(dataDir, { recursive: true });
        }
        await fs.writeFile(BOOKS_FILE, '[]', 'utf8');
        console.log('Created books.json file');
    }
}

// POST /api/save - Save a new book
app.post('/api/save', async (req, res) => {
    try {
        const { title, author, notes } = req.body;

        // Validate input
        if (!title || !author) {
            return res.status(400).json({ 
                success: false, 
                error: 'Başlık ve yazar alanları zorunludur.' 
            });
        }

        // Read existing books
        const data = await fs.readFile(BOOKS_FILE, 'utf8');
        const books = JSON.parse(data);

        // Create new book object
        const newBook = {
            id: Date.now().toString(),
            title: title.trim(),
            author: author.trim(),
            notes: notes ? notes.trim() : '',
            createdAt: new Date().toISOString()
        };

        // Add to array
        books.push(newBook);

        // Write back to file
        await fs.writeFile(BOOKS_FILE, JSON.stringify(books, null, 2), 'utf8');

        console.log(`Book saved: ${newBook.title} by ${newBook.author}`);

        res.json({ 
            success: true, 
            message: 'Kitap başarıyla kaydedildi.',
            book: newBook 
        });
    } catch (error) {
        console.error('Error saving book:', error);
        res.status(500).json({ 
            success: false, 
            error: 'Kitap kaydedilirken bir hata oluştu.' 
        });
    }
});

// GET /api/books - Get all books (optional endpoint for future use)
app.get('/api/books', async (req, res) => {
    try {
        const data = await fs.readFile(BOOKS_FILE, 'utf8');
        const books = JSON.parse(data);
        res.json({ success: true, books });
    } catch (error) {
        console.error('Error reading books:', error);
        res.status(500).json({ 
            success: false, 
            error: 'Kitaplar okunurken bir hata oluştu.' 
        });
    }
});

// Start server
async function startServer() {
    await ensureDataFile();
    
    app.listen(PORT, () => {
        console.log(`\n🚀 Evde Kütüphane Web Sunucusu çalışıyor!`);
        console.log(`📚 Adres: http://localhost:${PORT}`);
        console.log(`📁 Kitaplar: ${BOOKS_FILE}\n`);
    });
}

startServer();
