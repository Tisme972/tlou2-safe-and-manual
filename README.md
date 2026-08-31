# The Last of Us Part II — Coffres & Manuels d'entraînement

Petite application web (statique, servie par nginx dans Docker) qui recense :
- les **14 coffres** du jeu avec leur combinaison, leur emplacement précis et des captures d'écran ;
- les **8 manuels d'entraînement** avec la branche de compétence débloquée et leur emplacement.

Recherche texte, filtre par chapitre, galerie d'images cliquable, et liens croisés entre coffres et manuels.

## Lancer le projet (sans rien cloner)

L'image est construite et publiée automatiquement sur GitHub Container Registry (GHCR) à chaque push, comme le fait par exemple `open-webui`. Aucun dossier local n'est nécessaire : Docker télécharge l'image et gère tout depuis Docker Desktop.

Le dépôt étant privé, l'image l'est aussi : il faut s'authentifier une fois auprès de GHCR (un token GitHub avec le scope `read:packages` suffit) :

```bash
docker login ghcr.io -u Tisme972
```

Puis, simplement :

```bash
docker run -d --name tlou2-guide -p 8080:80 --restart unless-stopped ghcr.io/tisme972/tlou2-safe-and-manual:latest
```

Ouvrir ensuite [http://localhost:8080](http://localhost:8080). Le conteneur `tlou2-guide` apparaît et se gère intégralement depuis Docker Desktop (start/stop/logs/suppression).

### Changer le port d'écoute

Remplacer `8080` par le port souhaité dans la commande ci-dessus (ex. `-p 9090:80`).

### Avec `docker-compose.yml` (si tu gardes le fichier sur ta machine)

```bash
PORT=9090 docker compose up -d
```

### Pour développer / modifier le code

```bash
git clone https://github.com/Tisme972/tlou2-safe-and-manual.git
cd tlou2-safe-and-manual
docker compose -f docker-compose.dev.yml up -d --build
```

## Structure

```
Dockerfile
docker-compose.yml
site/
  index.html
  style.css
  app.js
  data/
    coffres.json
    manuels.json
```

## Sources et crédits

Les textes et images sont issus de :
- [jeuxvideo.com — Localisation et combinaison des coffres](https://www.jeuxvideo.com/wikis-soluce-astuces/1236160/localisation-et-combinaison-des-coffres.htm)
- [supersoluce.com — Les manuels d'entraînement](https://www.supersoluce.com/soluce/last-us-2/les-manuels-d-entrainement)

Les images ne sont pas hébergées par ce projet : elles sont chargées directement depuis les sites sources.

Outil non officiel réalisé à usage personnel. Tous les droits sur *The Last of Us Part II* appartiennent à Naughty Dog / Sony Interactive Entertainment.
