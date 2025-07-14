document.addEventListener('DOMContentLoaded', () => {
    const langSelectorDiv = document.createElement('div');
    langSelectorDiv.id = 'language-selector';
    langSelectorDiv.className = 'text-center'; // Removed container and my-3

    const languages = [
        { code: 'en', name: 'English' },
        { code: 'fr', name: 'Français' },
        { code: 'de', name: 'Deutsch' },
        { code: 'it', name: 'Italiano' },
        { code: 'es', name: 'Español' },
        { code: 'sv', name: 'Svenska' },
        { code: 'eo', name: 'Esperanto' },
        { code: 'ro', name: 'Română' }
    ];

    languages.forEach(lang => {
        const langItem = document.createElement('span');
        langItem.className = 'lang-item mx-2';
        langItem.setAttribute('data-lang', lang.code);
        langItem.setAttribute('title', lang.name);

        const img = document.createElement('img');
        img.src = `img/flags/${lang.code}.png`;
        img.alt = lang.name;
        img.className = 'flag-icon';

        const codeSpan = document.createElement('span');
        codeSpan.className = 'lang-code';
        codeSpan.textContent = lang.code.toUpperCase();

        langItem.appendChild(img);
        langItem.appendChild(codeSpan);
        langSelectorDiv.appendChild(langItem);
    });

    document.body.appendChild(langSelectorDiv);

    const langSelects = document.querySelectorAll('.lang-item');
    let currentLang = localStorage.getItem('lang') || 'en'; // Default to English

    const loadLanguage = async (lang) => {
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
            document.documentElement.lang = lang;
            localStorage.setItem('lang', lang);

            // Update active class for flags
            langSelects.forEach(item => {
                if (item.getAttribute('data-lang') === lang) {
                    item.classList.add('active');
                } else {
                    item.classList.remove('active');
                }
            });

        } catch (error) {
            console.error('Error loading language file:', error);
        }
    };

    langSelects.forEach(select => {
        select.addEventListener('click', (event) => {
            event.preventDefault();
            const newLang = event.currentTarget.getAttribute('data-lang');
            loadLanguage(newLang);
        });
    });

    loadLanguage(currentLang);
});
