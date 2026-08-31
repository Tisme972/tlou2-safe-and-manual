# The Last of Us Part II — Coffres & Manuels d'entraînement

Petite application web (statique, servie par nginx dans Docker) qui recense :
- les **14 coffres** du jeu avec leur combinaison, leur emplacement précis et des captures d'écran ;
- les **8 manuels d'entraînement** avec la branche de compétence débloquée et leur emplacement.

Recherche texte, filtre par chapitre, galerie d'images cliquable, et liens croisés entre coffres et manuels.

## Lancer le projet
```bash
git clone https://github.com/Tisme972/tlou2-safe-and-manual.git
```
```bash
cd tlou2-sage-and-manual
```
```bash
docker compose up -d --build
```

Puis ouvrir [http://localhost:8080](http://localhost:8080).

Pour arrêter :

```bash
docker compose down
```

### Changer le port d'écoute

Le port par défaut est `8080`. Pour le changer, copier `.env.example` en `.env` et modifier la valeur :

```bash
cp .env.example .env
# éditer .env : PORT=9090
docker compose up -d --build
```

Ou directement en ligne de commande, sans fichier `.env` :

```bash
PORT=9090 docker compose up -d --build
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
