pipeline {
    agent any

    environment {
        // --- À CONFIGURER ---
        // Chemin vers l'exécutable Godot 4 sur votre agent Jenkins.
        // Mettez le chemin complet si Godot n'est pas dans le PATH.
        // Par exemple : '/usr/local/bin/godot' ou 'C:\Godot\Godot.exe'
        GODOT_EXECUTABLE = '/usr/local/bin/godot'

        // Le répertoire où les binaires seront créés.
        BUILD_DIR = 'builds'

        // Répertoires pour les fichiers temporaires de Godot dans l'environnement Jenkins
        GODOT_CONFIG_PATH = ".godot_jenkins/config"
        GODOT_DATA_PATH = ".godot_jenkins/data"
        GODOT_CACHE_PATH = ".godot_jenkins/cache"
    }

    stages {
        stage('Préparation') {
            steps {
                // Nettoie l'espace de travail avant de commencer
                

                // Crée les répertoires de build et pour les fichiers temporaires de Godot
                sh "mkdir -p ${env.BUILD_DIR}/windows"
                sh "mkdir -p ${env.BUILD_DIR}/linux_x11"
                sh "mkdir -p ${env.GODOT_CONFIG_PATH}"
                sh "mkdir -p ${env.GODOT_DATA_PATH}"
                sh "mkdir -p ${env.GODOT_CACHE_PATH}"

                // Copie les modèles d'exportation
                sh "mkdir -p export_templates/templates"
                sh "cp -r /usr/local/share/godot/export_templates/4.4.1.stable/* export_templates/templates/"
            }
        }

        stage('Build pour Windows') {
            steps {
                echo 'Exportation pour Windows...'
                // Exporte le projet en utilisant le preset "Windows Desktop".
                // L'option --headless est cruciale pour une exécution sur un serveur.
                // On spécifie les chemins pour les fichiers temporaires pour éviter les conflits avec l'environnement Snap de Jenkins.
                sh "'${env.GODOT_EXECUTABLE}' --headless --verbose --export-release WindowsDesktop '${env.BUILD_DIR}/windows/Dracula.exe' --config-path '${env.GODOT_CONFIG_PATH}' --data-path '${env.GODOT_DATA_PATH}' --cache-path '${env.GODOT_CACHE_PATH}'"
            }
        }

        stage('Build pour Linux (X11 & Wayland)') {
            steps {
                echo 'Exportation pour Linux...'
                // Exporte le projet en utilisant le preset "Linux/X11".
                // Ce binaire fonctionnera à la fois sur les sessions X11 et Wayland (via XWayland).
                sh "'${env.GODOT_EXECUTABLE}' --headless --export-release 'Linux' '${env.BUILD_DIR}/linux_x11/Dracula.x86_64' --config-path '${env.GODOT_CONFIG_PATH}' --data-path '${env.GODOT_DATA_PATH}' --cache-path '${env.GODOT_CACHE_PATH}'"
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
