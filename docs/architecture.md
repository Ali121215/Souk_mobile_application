# Architecture technique — Souk

Résumé de l'architecture validée (voir la conversation de conception pour les diagrammes complets).

## Vue d'ensemble

```
App mobile (Flutter)
        │
        ▼
API backend (NestJS) — monolithe modulaire
  ├── Auth          (téléphone + OTP)
  ├── Listings      (annonces classifiées)
  ├── Restaurants   (menus, commandes, livraison)
  ├── Jobs          (offres d'emploi, candidatures)
  └── Messaging     (conversations acheteur/vendeur)
        │
        ▼
PostgreSQL + PostGIS  ·  Redis (cache, files d'attente)
```

## Services externes

| Service | Rôle |
|---|---|
| SMS OTP | Connexion par téléphone (fournisseur à confirmer) |
| Airtel Money / Moov Money | Paiement mobile money |
| Stockage S3-compatible | Photos des annonces et restaurants |
| Notifications push (FCM) | Alertes commandes, messages, candidatures |

## Principes retenus

- **Monolithe modulaire, pas de microservices** au démarrage — plus simple à maintenir pour une petite équipe, chaque domaine reste isolé dans son module NestJS.
- **PostGIS** pour toutes les requêtes géographiques ("restaurants près de moi", "annonces dans un rayon de X km").
- **Redis** pour le cache et les files d'attente (SMS, notifications, traitement d'images en arrière-plan).
- **Offline-first côté mobile** : cache local (Drift/SQLite) des dernières annonces consultées, pagination systématique, images compressées en WebP.
- **Modération avant publication** pour les annonces et les restaurants, comme sur Avito.

## Schéma de base de données (entités principales)

`users`, `listings`, `categories`, `restaurants`, `menu_items`, `orders`, `order_items`, `job_offers`, `job_applications`, `messages` — voir le code des entités dans `backend/src/*/`.
