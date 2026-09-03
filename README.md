# The Last of Us Part II — Coffres & Manuels d'entraînement

Petite application web (statique, servie par nginx dans Docker) qui recense :
- les **14 coffres** du jeu avec leur combinaison, leur emplacement précis et des captures d'écran ;
- les **8 manuels d'entraînement** avec la branche de compétence débloquée et leur emplacement.

Recherche texte, filtre par chapitre, galerie d'images cliquable, et liens croisés entre coffres et manuels.

---

## 🚀 Démarrage Rapide

### Sans cloner (juste Docker)

L'image est construite et publiée automatiquement sur GHCR à chaque `push`. Aucune authentification requise.

```bash
docker run -d --name tlou2-guide -p 8080:80 --restart unless-stopped ghcr.io/tisme972/tlou2-safe-and-manual:latest
```

Accéder à [http://localhost:8080](http://localhost:8080) 🎮

---

## 📋 Gestion via Docker Desktop

Une fois le conteneur créé :

- **Démarrer** : bouton ▶️
- **Arrêter** : bouton ⏹️
- **Consulter les logs** : onglet "Logs"
- **Supprimer** : clic droit → Delete
- **Paramètres** : clic droit → Settings

---

## 💻 Gestion via Ligne de Commande

### Avec `Makefile` (Recommandé - **Plus simple**)

À la racine du projet :

```bash
# Démarrer
make up

# Avec un port personnalisé
PORT=9090 make up

# Voir les logs
make logs

# Arrêter
make stop

# Redémarrer
make restart

# Arrêter et supprimer
make down

# Voir toutes les commandes
make help
```

### Avec le Script `manage.sh` (Alternative)

```bash
# Rendre exécutable
chmod +x manage.sh

# Démarrer
./manage.sh start

# Avec un port personnalisé
./manage.sh start --port 9090

# Voir les logs
./manage.sh logs

# Arrêter
./manage.sh stop

# Redémarrer
./manage.sh restart

# Mettre à jour depuis GHCR
./manage.sh update

# Mode développement
./manage.sh dev

# Aide
./manage.sh help
```

### Avec `docker-compose` directement

```bash
# Démarrer
docker compose up -d

# Avec un port personnalisé
PORT=9090 docker compose up -d

# Voir les logs
docker compose logs -f

# Arrêter
docker compose stop

# Arrêter et supprimer
docker compose down
```

### Avec `docker run` simple

```bash
docker run -d --name tlou2-guide -p 8080:80 --restart unless-stopped ghcr.io/tisme972/tlou2-safe-and-manual:latest

# Voir les logs
docker logs -f tlou2-guide

# Arrêter
docker stop tlou2-guide

# Redémarrer
docker start tlou2-guide

# Supprimer
docker rm tlou2-guide
```

---

## 🔧 Mode Développement

Pour modifier le code localement :

```bash
# Cloner
git clone https://github.com/Tisme972/tlou2-safe-and-manual.git
cd tlou2-safe-and-manual

# Démarrer en mode watch (reconstruit automatiquement)
make dev-up
# ou
./manage.sh dev
# ou
docker compose -f docker-compose.dev.yml up -d --build
```

Arrêter :

```bash
make dev-down
# ou
./manage.sh dev-stop
# ou
docker compose -f docker-compose.dev.yml down
```

---

## 🔄 Mettre à jour vers la dernière version

```bash
# Avec Makefile
make update

# Avec le script
./manage.sh update

# Manuellement
docker pull ghcr.io/tisme972/tlou2-safe-and-manual:latest
docker compose up -d
```

---

## 🐛 Troubleshooting

**Le conteneur ne démarre pas :**

```bash
docker compose logs
# ou
make logs
```

**Le port est déjà utilisé :**

```bash
PORT=9090 make up
# ou
./manage.sh start --port 9090
```

**Voir le statut :**

```bash
docker ps
# ou
make ps
```

**Supprimer complètement :**

```bash
make clean
# ou
./manage.sh clean
```

---

## 📦 Structure

```
.
├── Dockerfile
├── docker-compose.yml
├── docker-compose.dev.yml
├── Makefile
├── manage.sh
├── README.md
└── site/
    ├── index.html
    ├── style.css
    ├── app.js
    └── data/
        ├── coffres.json
        └── manuels.json
```

---

## 📚 Sources

- [jeuxvideo.com — Coffres](https://www.jeuxvideo.com/wikis-soluce-astuces/1236160/localisation-et-combinaison-des-coffres.htm)
- [supersoluce.com — Manuels](https://www.supersoluce.com/soluce/last-us-2/les-manuels-d-entrainement)

Tous les droits sur *The Last of Us Part II* appartiennent à Naughty Dog / Sony Interactive Entertainment.
