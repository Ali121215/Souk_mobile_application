/**
 * Insère quelques annonces de démonstration déjà publiées, pour pouvoir tester
 * l'écran Accueil du mobile sans passer par la modération.
 *
 * Usage : npm run seed
 */
import { NestFactory } from '@nestjs/core';
import { getRepositoryToken } from '@nestjs/typeorm';
import { AppModule } from './app.module';
import { Listing, ListingStatus } from './listings/listing.entity';

async function seed() {
  const app = await NestFactory.createApplicationContext(AppModule);
  const repo = app.get(getRepositoryToken(Listing));

  const vendeurIdDemo = '00000000-0000-0000-0000-000000000000';

  const demoListings = [
    { titre: 'Villa 4 chambres — Sabangali', categorie: 'immobilier', prixFcfa: 45000000, ville: "N'Djamena" },
    { titre: 'Toyota Hilux 2018', categorie: 'vehicules', prixFcfa: 12500000, ville: 'Moundou' },
    { titre: 'Groupe électrogène 5KVA', categorie: 'materiel', prixFcfa: 850000, ville: "N'Djamena" },
    { titre: 'iPhone 13 Pro — 128Go', categorie: 'electronique', prixFcfa: 310000, ville: 'Sarh' },
    { titre: 'Moto Jincheng 125cc', categorie: 'vehicules', prixFcfa: 950000, ville: "N'Djamena" },
    { titre: 'Terrain 600m² — Diguel', categorie: 'immobilier', prixFcfa: 9500000, ville: "N'Djamena" },
  ];

  for (const data of demoListings) {
    const listing = repo.create({
      ...data,
      vendeurId: vendeurIdDemo,
      statut: ListingStatus.PUBLIEE,
    });
    await repo.save(listing);
  }

  console.log(`${demoListings.length} annonces de démonstration insérées.`);
  await app.close();
}

seed().catch((err) => {
  console.error('Erreur pendant le seed :', err);
  process.exit(1);
});
