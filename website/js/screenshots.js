document.addEventListener('DOMContentLoaded', async () => {
    const gallery = document.getElementById('screenshots-gallery');

    try {
        const response = await fetch('../screenshots.json');
        const images = await response.json();

        if (images && images.length > 0) {
            images.forEach(src => {
                const colDiv = document.createElement('div');
                colDiv.className = 'col-md-6 mb-4'; // Two images per row on medium screens

                const img = document.createElement('img');
                img.src = src;
                img.alt = 'Dracula Screenshot';
                img.className = 'img-fluid rounded shadow-sm';

                colDiv.appendChild(img);
                gallery.appendChild(colDiv);
            });
        } else {
            gallery.innerHTML = '<p>Aucune capture d\'écran disponible pour le moment.</p>';
        }
    } catch (error) {
        console.error('Error loading screenshots.json:', error);
        gallery.innerHTML = '<p class="text-danger">Impossible de charger les captures d\'écran.</p>';
    }
});