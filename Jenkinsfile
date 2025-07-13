pipeline {
    agent any

    environment {
        // --- À CONFIGURER ---
        // Chemin vers l'exécutable Godot 4 sur votre agent Jenkins.
        // Mettez le chemin complet si Godot n'est pas dans le PATH.
        // Par exemple : '/usr/local/bin/godot' ou 'C:\Godot\Godot.exe'
        GODOT_EXECUTABLE = '/snap/bin/godot-4'

        // Le répertoire où les binaires seront créés.
        BUILD_DIR = 'builds'
    }

    stages {
        stage('Préparation') {
            steps {
                // Nettoie l'espace de travail avant de commencer
                

                // Crée le répertoire de build s'il n'existe pas
                sh "mkdir -p ${env.BUILD_DIR}/windows"
                sh "mkdir -p ${env.BUILD_DIR}/linux_x11"
            }
        }

        stage('Build pour Windows') {
            steps {
                echo 'Exportation pour Windows...'
                // Exporte le projet en utilisant le preset "Windows Desktop".
                // L'option --headless est cruciale pour une exécution sur un serveur.
                sh "'${env.GODOT_EXECUTABLE}' --headless --verbose --export-release WindowsDesktop '${env.BUILD_DIR}/windows/Dracula.exe'"
            }
        }

        stage('Build pour Linux (X11 & Wayland)') {
            steps {
                echo 'Exportation pour Linux...'
                // Exporte le projet en utilisant le preset "Linux/X11".
                // Ce binaire fonctionnera à la fois sur les sessions X11 et Wayland (via XWayland).
                sh "'${env.GODOT_EXECUTABLE}' --headless --export-release 'Linux' '${env.BUILD_DIR}/linux_x11/Dracula.x86_64'"
            }
        }

        stage('Archivage des binaires') {
            steps {
                echo 'Archivage des binaires...'
                // Archive tout le contenu du répertoire de build.
                // Les fichiers seront disponibles sur la page du build Jenkins.
                archiveArtifacts artifacts: "${env.BUILD_DIR}/**", fingerprint: true
            }
        }
    }

    post {
        always {
            echo 'Pipeline terminé.'
        }
    }
}
