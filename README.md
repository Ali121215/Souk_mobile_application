# Souk — marketplace multi-services mobile pour le Tchad

Annonces classifiées · Livraison de repas · Immobilier · Véhicules · Emploi

> Nom de travail : **Souk**. À valider définitivement avant le lancement public (voir le cahier des charges).

## Structure du dépôt

```
souk/
├── backend/     API NestJS (Node.js/TypeScript) — modules Auth, Listings, Restaurants, Jobs, Messaging
├── mobile/      Application Flutter (Android/iOS)
└── docs/        Cahier des charges, notes d'architecture
```

## Démarrer le backend

Prérequis : Node.js 20+, Docker (pour la base de données locale).

```bash
cd backend
cp .env.example .env
docker compose up -d        # démarre PostgreSQL + PostGIS et Redis en local
npm install
npm run start:dev           # API disponible sur http://localhost:3000/api/v1
```

Vérifier que ça fonctionne : `curl http://localhost:3000/api/v1/health`

Le backend a déjà été validé dans cette session : `npm install` + `npx nest build` passent sans erreur.

## Démarrer l'application mobile

Prérequis : [Flutter SDK](https://docs.flutter.dev/get-started/install) installé sur votre machine (non disponible dans cet environnement de préparation, donc à tester de votre côté).

```bash
cd mobile
flutter pub get
flutter run                 # lance sur un émulateur ou un téléphone connecté
```

> Le code Flutter fourni est un squelette de départ : écrans statiques reliés à la navigation par onglets, mais pas encore connectés à l'API. Prochaine étape : brancher chaque écran sur le backend via `dio`.

## État actuel du projet

- [x] Maquette interactive validée (voir `docs/`)
- [x] Cahier des charges et étude de marché
- [x] Architecture technique définie
- [x] Squelette backend (5 modules, compile et build sans erreur)
- [x] Squelette mobile (navigation + écrans de base)
- [ ] Authentification réelle (JWT + vraie vérification OTP par SMS)
- [ ] Connexion mobile ↔ API
- [ ] Intégration Airtel Money / Moov Money
- [ ] Upload de photos vers le stockage médias

## Prochaines étapes suggérées

1. Brancher l'écran Accueil sur `GET /api/v1/listings`
2. Implémenter un vrai fournisseur SMS pour l'OTP (module Auth)
3. Générer un vrai JWT à la connexion et sécuriser les routes qui en ont besoin
