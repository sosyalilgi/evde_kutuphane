// save.js - Handle book form submission

document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('bookForm');
    const submitBtn = document.getElementById('submitBtn');
    const submitText = document.getElementById('submitText');
    const submitSpinner = document.getElementById('submitSpinner');
    const alertPlaceholder = document.getElementById('alertPlaceholder');

    // Show alert message
    function showAlert(message, type) {
        const alertDiv = document.createElement('div');
        alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
        alertDiv.role = 'alert';
        alertDiv.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        `;
        alertPlaceholder.innerHTML = '';
        alertPlaceholder.appendChild(alertDiv);

        // Auto-dismiss after 5 seconds
        setTimeout(() => {
            alertDiv.remove();
        }, 5000);
    }

    // Set loading state
    function setLoading(loading) {
        if (loading) {
            submitBtn.disabled = true;
            submitText.textContent = 'Kaydediliyor...';
            submitSpinner.classList.remove('d-none');
        } else {
            submitBtn.disabled = false;
            submitText.textContent = 'Kaydet';
            submitSpinner.classList.add('d-none');
        }
    }

    // Handle form submission
    form.addEventListener('submit', async function(e) {
        e.preventDefault();

        // Get form data
        const formData = {
            title: document.getElementById('title').value.trim(),
            author: document.getElementById('author').value.trim(),
            notes: document.getElementById('notes').value.trim()
        };

        // Validate
        if (!formData.title || !formData.author) {
            showAlert('Lütfen başlık ve yazar alanlarını doldurun.', 'warning');
            return;
        }

        // Set loading state
        setLoading(true);

        try {
            // Send POST request to /api/save
            const response = await fetch('/api/save', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            });

            const data = await response.json();

            if (response.ok) {
                // Success
                showAlert('✅ Kitap başarıyla kaydedildi!', 'success');
                
                // Reset form
                form.reset();
            } else {
                // Error from server
                showAlert(`❌ Hata: ${data.error || 'Bilinmeyen hata'}`, 'danger');
            }
        } catch (error) {
            // Network or other error
            console.error('Error:', error);
            showAlert('❌ Bağlantı hatası. Sunucunun çalıştığından emin olun.', 'danger');
        } finally {
            // Remove loading state
            setLoading(false);
        }
    });
});
