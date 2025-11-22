// Handle book form submission
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('bookForm');
    const saveBtn = document.getElementById('saveBtn');
    const btnText = document.getElementById('btnText');
    const btnSpinner = document.getElementById('btnSpinner');
    const alertPlaceholder = document.getElementById('alertPlaceholder');

    // Show alert function
    function showAlert(message, type) {
        const alertHTML = `
            <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        `;
        alertPlaceholder.innerHTML = alertHTML;
        
        // Auto-dismiss after 5 seconds
        setTimeout(() => {
            const alert = alertPlaceholder.querySelector('.alert');
            if (alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }
        }, 5000);
    }

    // Set loading state
    function setLoading(isLoading) {
        saveBtn.disabled = isLoading;
        if (isLoading) {
            btnText.classList.add('d-none');
            btnSpinner.classList.remove('d-none');
        } else {
            btnText.classList.remove('d-none');
            btnSpinner.classList.add('d-none');
        }
    }

    // Handle form submission
    form.addEventListener('submit', async function(e) {
        e.preventDefault();
        
        // Get form data
        const formData = new FormData(form);
        const bookData = {
            title: formData.get('title'),
            author: formData.get('author'),
            notes: formData.get('notes') || '',
            createdAt: new Date().toISOString()
        };

        // Set loading state
        setLoading(true);
        alertPlaceholder.innerHTML = '';

        try {
            // Send POST request to API
            const response = await fetch('/api/save', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(bookData)
            });

            const result = await response.json();

            if (response.ok) {
                // Success
                showAlert(`✓ Kitap başarıyla kaydedildi: "${bookData.title}"`, 'success');
                form.reset();
            } else {
                // Error from server
                showAlert(`✗ Hata: ${result.error || 'Kitap kaydedilemedi'}`, 'danger');
            }
        } catch (error) {
            // Network or other error
            console.error('Error saving book:', error);
            showAlert(`✗ Bağlantı hatası: ${error.message}`, 'danger');
        } finally {
            // Reset loading state
            setLoading(false);
        }
    });
});
