// Form submit handler
document.getElementById('bookForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const submitBtn = document.getElementById('submitBtn');
    const btnText = document.getElementById('btnText');
    const btnSpinner = document.getElementById('btnSpinner');
    const alertPlaceholder = document.getElementById('alertPlaceholder');
    
    // Clear previous alerts
    alertPlaceholder.innerHTML = '';
    
    // Disable button and show loading state
    submitBtn.disabled = true;
    btnText.textContent = 'Kaydediliyor...';
    btnSpinner.classList.remove('d-none');
    
    // Collect form data
    const formData = {
        title: document.getElementById('title').value.trim(),
        author: document.getElementById('author').value.trim(),
        publisher: document.getElementById('publisher').value.trim(),
        isbn: document.getElementById('isbn').value.trim(),
        pageCount: Math.max(0, parseInt(document.getElementById('pageCount').value) || 0),
        location: document.getElementById('location').value.trim(),
        tags: document.getElementById('tags').value.trim(),
        note: document.getElementById('note').value.trim(),
        createdAt: new Date().toISOString()
    };
    
    try {
        const response = await fetch('/api/save', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(formData)
        });
        
        const result = await response.json();
        
        if (response.ok) {
            // Success
            showAlert('success', `✓ Kitap başarıyla kaydedildi: "${formData.title}"`);
            document.getElementById('bookForm').reset();
            
            // Scroll to top to see success message
            window.scrollTo({ top: 0, behavior: 'smooth' });
        } else {
            // Error from server
            showAlert('danger', `✗ Hata: ${result.error || 'Kayıt başarısız oldu'}`);
        }
    } catch (error) {
        // Network or other error
        console.error('Error:', error);
        showAlert('danger', `✗ Bağlantı hatası: ${error.message}`);
    } finally {
        // Re-enable button and restore original state
        submitBtn.disabled = false;
        btnText.textContent = 'Kaydet';
        btnSpinner.classList.add('d-none');
    }
});

// Helper function to show alerts
function showAlert(type, message) {
    const alertPlaceholder = document.getElementById('alertPlaceholder');
    const wrapper = document.createElement('div');
    
    // Create alert element safely
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
    alertDiv.setAttribute('role', 'alert');
    
    // Use textContent to prevent XSS
    const messageText = document.createTextNode(message);
    alertDiv.appendChild(messageText);
    
    // Add close button
    const closeButton = document.createElement('button');
    closeButton.type = 'button';
    closeButton.className = 'btn-close';
    closeButton.setAttribute('data-bs-dismiss', 'alert');
    closeButton.setAttribute('aria-label', 'Close');
    alertDiv.appendChild(closeButton);
    
    wrapper.appendChild(alertDiv);
    alertPlaceholder.appendChild(wrapper);
    
    // Auto-dismiss success alerts after 5 seconds
    if (type === 'success') {
        setTimeout(() => {
            const alert = wrapper.querySelector('.alert');
            if (alert) {
                const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
                bsAlert.close();
            }
        }, 5000);
    }
}

// Form validation feedback
document.getElementById('title').addEventListener('input', (e) => {
    if (e.target.value.trim()) {
        e.target.classList.remove('is-invalid');
        e.target.classList.add('is-valid');
    } else {
        e.target.classList.remove('is-valid');
        e.target.classList.add('is-invalid');
    }
});
