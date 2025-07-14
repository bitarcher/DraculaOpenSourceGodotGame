pipeline {
    agent any

    environment {
        // --- À CONFIGURER ---
        // Chemin vers l'exécutable Godot 4 sur votre agent Jenkins.
        // Mettez le chemin complet si Godot n'est pas dans le PATH.
        // Par exemple : '/usr/local/bin/godot' ou 'C:\Godot\Godot.exe'
        GODOT_EXECUTABLE = 'godot_portable/godot'

        // Le répertoire où les binaires seront créés.
        BUILD_DIR = 'builds'
    }

    stages {
        stage('Préparation') {
            steps {
                // Nettoie l'espace de travail avant de commencer
                

                // Crée le répertoire de build
                sh "mkdir -p ${env.BUILD_DIR}/windows"
                sh "mkdir -p ${env.BUILD_DIR}/linux_x11"

                // Crée une version portable de Godot pour isoler l'environnement
                sh "mkdir -p godot_portable"
                sh "cp /usr/local/bin/godot godot_portable/"
                sh "touch godot_portable/_sc_"

                // Copie les modèles d'exportation
                sh "mkdir -p godot_portable/editor_data/export_templates/4.4.1.stable"
                sh "cp -r /usr/local/share/godot/export_templates/4.4.1.stable/* godot_portable/editor_data/export_templates/4.4.1.stable/"
            }
        }

        stage('Build pour Windows') {
            steps {
                echo 'Exportation pour Windows...'
                // Exporte le projet en utilisant le preset "Windows Desktop".
                // L'option --headless est cruciale pour une exécution sur un serveur.
                sh "'${env.GODOT_EXECUTABLE}' --headless --verbose --export-release WindowsDesktop '${env.BUILD_DIR}/windows/Dracula.exe'"
                // Crée une archive ZIP pour Windows
                sh "cd ${env.BUILD_DIR}/windows && zip -r Dracula_Windows.zip Dracula.exe Dracula.pck"
            }
        }

        stage('Build pour Linux (X11 & Wayland)') {
            steps {
                echo 'Exportation pour Linux...'
                // Exporte le projet en utilisant le preset "Linux/X11".
                // Ce binaire fonctionnera à la fois sur les sessions X11 et Wayland (via XWayland).
                sh "'${env.GODOT_EXECUTABLE}' --headless --export-release 'Linux' '${env.BUILD_DIR}/linux_x11/Dracula.x86_64'"
                // Crée une archive tar.gz pour Linux
                sh "cd ${env.BUILD_DIR}/linux_x11 && tar -czvf Dracula_Linux.tar.gz Dracula.x86_64 Dracula.pck"
            }
        }

        stage('Archivage des binaires') {
            steps {
                echo 'Archivage des binaires...'
                // Archive les fichiers ZIP et tar.gz créés.
                // Les fichiers seront disponibles sur la page du build Jenkins.
                archiveArtifacts artifacts: "${env.BUILD_DIR}/windows/*.zip, ${env.BUILD_DIR}/linux_x11/*.tar.gz", fingerprint: true
            }
        }

        stage('Création de la Release GitHub') {
            steps {
                script {
                    def now = new Date().format('yyyyMMdd_HHmmss')
                    def windowsZip = "${env.BUILD_DIR}/windows/Dracula_Windows.zip"
                    def linuxTarGz = "${env.BUILD_DIR}/linux_x11/Dracula_Linux.tar.gz"

                    def newWindowsZipName = "Dracula_Windows_${now}.zip"
                    def newLinuxTarGzName = "Dracula_Linux_${now}.tar.gz"

                    sh "mv ${windowsZip} ${env.BUILD_DIR}/windows/${newWindowsZipName}"
                    sh "mv ${linuxTarGz} ${env.BUILD_DIR}/linux_x11/${newLinuxTarGzName}"

                    // Générer un changelog simple à partir des derniers commits
                    def changelog = sh(returnStdout: true, script: 'git log --pretty=format:"- %s" --since="1 week ago"').trim()
                    if (changelog.isEmpty()) {
                        changelog = "No significant changes in the last week."
                    }

                    echo "Changelog:\n${changelog}"

                    // --- PLACEHOLDER POUR LA CRÉATION DE RELEASE GITHUB ---
                    // Vous devriez utiliser le plugin GitHub de Jenkins pour une meilleure intégration.
                    // Exemple avec l'outil `gh` (GitHub CLI) si installé sur l'agent Jenkins:
                    // sh "gh release create v${now} --title \"Release ${now}\" --notes \"${changelog}\" ${env.BUILD_DIR}/windows/${newWindowsZipName} ${env.BUILD_DIR}/linux_x11/${newLinuxTarGzName}"

                    // Exemple avec curl (nécessite un token GitHub dans les credentials Jenkins):
                    // def githubToken = credentials('YOUR_GITHUB_TOKEN_ID') // Remplacez par l'ID de votre credential Jenkins
                    // sh "curl -X POST -H \"Accept: application/vnd.github.v3+json\" -H \"Authorization: token ${githubToken}\" https://api.github.com/repos/YOUR_USERNAME/YOUR_REPOSITORY/releases -d '{\"tag_name\":\"v${now}\",\"name\":\"Release ${now}\",\"body\":\"${changelog}\",\"draft\":false,\"prerelease\":false}'"
                    // Après la création de la release, vous devrez uploader les assets séparément avec curl ou gh cli.
                    // C'est pourquoi le plugin GitHub est fortement recommandé.

                    echo "Fichiers renommés: ${newWindowsZipName} et ${newLinuxTarGzName}"
                    echo "Veuillez configurer la création de la release GitHub manuellement ou via le plugin Jenkins."
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline terminé.'
        }
    }
}