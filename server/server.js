const express = require('express');
const fs = require('fs').promises;
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;
const DATA_FILE = path.join(__dirname, '..', 'data', 'books.json');

// Middleware
app.use(express.json());
app.use(express.static(path.join(__dirname, '..', 'public')));

// Ensure data file exists
async function ensureDataFile() {
    try {
        await fs.access(DATA_FILE);
    } catch {
        // File doesn't exist, create it with empty array
        await fs.mkdir(path.dirname(DATA_FILE), { recursive: true });
        await fs.writeFile(DATA_FILE, '[]', 'utf8');
        console.log('Created data/books.json file');
    }
}

// POST /api/save - Save a new book
app.post('/api/save', async (req, res) => {
    try {
        const { title, author, notes } = req.body;

        // Validation
        if (!title || !author) {
            return res.status(400).json({ 
                error: 'Başlık ve yazar zorunludur' 
            });
        }

        // Read existing books
        const data = await fs.readFile(DATA_FILE, 'utf8');
        const books = JSON.parse(data);

        // Create new book entry
        const newBook = {
            id: Date.now().toString(),
            title: title.trim(),
            author: author.trim(),
            notes: notes ? notes.trim() : '',
            createdAt: new Date().toISOString()
        };

        // Add to books array
        books.push(newBook);

        // Save to file
        await fs.writeFile(DATA_FILE, JSON.stringify(books, null, 2), 'utf8');

        console.log(`Book saved: "${title}" by ${author}`);

        res.status(201).json({ 
            success: true, 
            message: 'Kitap başarıyla kaydedildi',
            book: newBook 
        });
    } catch (error) {
        console.error('Error saving book:', error);
        res.status(500).json({ 
            error: 'Kitap kaydedilirken bir hata oluştu' 
        });
    }
});

// GET /api/books - Get all books (optional, for future use)
app.get('/api/books', async (req, res) => {
    try {
        const data = await fs.readFile(DATA_FILE, 'utf8');
        const books = JSON.parse(data);
        res.json(books);
    } catch (error) {
        console.error('Error reading books:', error);
        res.status(500).json({ 
            error: 'Kitaplar yüklenirken bir hata oluştu' 
        });
    }
});

// Start server
async function startServer() {
    await ensureDataFile();
    app.listen(PORT, () => {
        console.log(`
╔════════════════════════════════════════╗
║   Evde Kütüphane Server Başlatıldı    ║
╚════════════════════════════════════════╝

🚀 Server çalışıyor: http://localhost:${PORT}
📚 Kitap eklemek için tarayıcınızdan açın
💾 Veriler kaydediliyor: ${DATA_FILE}

Durdurmak için: Ctrl+C
        `);
    });
}

startServer().catch(error => {
    console.error('Failed to start server:', error);
    process.exit(1);
});
