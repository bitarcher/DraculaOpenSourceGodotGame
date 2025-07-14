document.addEventListener('DOMContentLoaded', async () => {
    if (document.getElementById('download-list')) {
        try {
            const response = await fetch('https://api.github.com/repos/bitarcher/DraculaOpenSourceGodotGame/releases');
            const githubReleases = await response.json();

            const versions = githubReleases.map(release => {
                const releaseDate = new Date(release.published_at);
                const formattedDate = releaseDate.toLocaleDateString('fr-FR', { year: 'numeric', month: 'long', day: 'numeric' });

                const files = release.assets.map(asset => {
                    let displayName = asset.name;
                    let format = '';

                    if (asset.name.includes('Windows')) {
                        displayName = 'Windows Executable';
                        format = 'ZIP';
                    } else if (asset.name.includes('Linux')) {
                        displayName = 'Linux Executable';
                        format = 'TAR.GZ';
                    }
                    // Add more conditions for other platforms/formats if needed

                    return {
                        display_name: displayName,
                        url: asset.browser_download_url,
                        format: format
                    };
                });

                return {
                    version: release.tag_name,
                    date: formattedDate,
                    description: release.body || 'No description provided.',
                    files: files
                };
            });

            const downloadListDiv = document.getElementById('download-list');
            downloadListDiv.innerHTML = ''; // Clear existing content

            // Display latest version
            if (versions.length > 0) {
                const latestVersion = versions[0];
                const latestHtml = `
                    <h3><span data-lang-key="download_page.latest_version">Dernière version</span>: ${latestVersion.version} (${latestVersion.date})</h3>
                    <p>${latestVersion.description}</p>
                    <div class="row">
                        ${latestVersion.files.map(file => `
                            <div class="col-md-4 mb-3">
                                <div class="card">
                                    <div class="card-body">
                                        <h5 class="card-title">${file.display_name}</h5>
                                        <a href="${file.url}" class="btn btn-success" data-lang-key="download_page.download_button">Télécharger (${file.format})</a>
                                    </div>
                                </div>
                            </div>
                        `).join('')}
                    </div>
                    <hr>
                `;
                downloadListDiv.innerHTML += latestHtml;
            }

            // Display other versions
            if (versions.length > 1) {
                const otherVersionsHtml = `
                    <h3><span data-lang-key="download_page.other_versions">Autres versions</span>:</h3>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th data-lang-key="download_page.version">Version</th>
                                <th data-lang-key="download_page.date">Date</th>
                                <th>Description</th>
                                <th data-lang-key="download_page.platform">Plateforme</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            ${versions.slice(1).map(version => `
                                <tr>
                                    <td>${version.version}</td>
                                    <td>${version.date}</td>
                                    <td>${version.description}</td>
                                    <td>
                                        ${version.files.map(file => `
                                            <a href="${file.url}" class="btn btn-sm btn-outline-primary mb-1">${file.display_name} (${file.format})</a>
                                        `).join(' ')}
                                    </td>
                                    <td></td>
                                </tr>
                            `).join('')}
                        </tbody>
                    </table>
                `;
                downloadListDiv.innerHTML += otherVersionsHtml;
            }

            // Re-apply language translations after content is loaded
            const currentLang = localStorage.getItem('lang') || 'en';
            const event = new CustomEvent('languageChange', { detail: currentLang });
            document.dispatchEvent(event);

        } catch (error) {
            console.error('Error loading releases from GitHub API:', error);
            const downloadListDiv = document.getElementById('download-list');
            downloadListDiv.innerHTML = '<p class="text-danger">Impossible de charger les informations de téléchargement depuis GitHub.</p>';
        }
    }
});

// Listen for custom languageChange event to re-translate dynamic content
document.addEventListener('languageChange', async (event) => {
    const lang = event.detail;
    try {
        const response = await fetch(`lang/${lang}.json`);
        const translations = await response.json();
        document.querySelectorAll('[data-lang-key]').forEach(element => {
            const key = element.getAttribute('data-lang-key');
            const keys = key.split('.');
            let text = translations;
            for (const k of keys) {
                if (text && text[k]) {
                    text = text[k];
                } else {
                    text = ''; // Fallback if key not found
                    break;
                }
            }
            element.textContent = text;
        });
    } catch (error) {
        console.error('Error re-translating dynamic content:', error);
    }
});
