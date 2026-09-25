import { NestFactory } from '@nestjs/core';
import { getRepositoryToken } from '@nestjs/typeorm';
import { AppModule } from './app.module';
import { Restaurant } from './restaurants/restaurant.entity';
import { MenuItem } from './restaurants/menu-item.entity';

async function seed() {
  const app = await NestFactory.createApplicationContext(AppModule);
  const restaurantRepo = app.get(getRepositoryToken(Restaurant));
  const menuItemRepo = app.get(getRepositoryToken(MenuItem));

  const data = [
    {
      nom: 'Chez Fatime',
      ville: "N'Djamena",
      note: 4.6,
      fraisLivraisonFcfa: 800,
      delaiLivraisonMinutes: 30,
      menu: [
        { nom: 'Brochettes de boeuf (6pcs)', prixFcfa: 2500 },
        { nom: 'Poulet DG', prixFcfa: 4000 },
        { nom: 'Salade tchadienne', prixFcfa: 1200 },
        { nom: 'Jus de bissap', prixFcfa: 800 },
      ],
    },
    {
      nom: 'Le Sahel Grill',
      ville: "N'Djamena",
      note: 4.8,
      fraisLivraisonFcfa: 0,
      delaiLivraisonMinutes: 25,
      menu: [
        { nom: 'Demi-poulet grille + frites', prixFcfa: 3500 },
        { nom: 'Poulet entier grille', prixFcfa: 6500 },
        { nom: 'Riz gras + brochette', prixFcfa: 2800 },
        { nom: 'Coca-Cola 33cl', prixFcfa: 500 },
      ],
    },
    {
      nom: "Saveurs N'Djam",
      ville: "N'Djamena",
      note: 4.3,
      fraisLivraisonFcfa: 1000,
      delaiLivraisonMinutes: 35,
      menu: [
        { nom: 'Boule + sauce gombo', prixFcfa: 1800 },
        { nom: 'Daraba + viande', prixFcfa: 2200 },
        { nom: 'Beignets (10pcs)', prixFcfa: 700 },
        { nom: 'Bissap glace', prixFcfa: 600 },
      ],
    },
  ];

  for (const r of data) {
    const restaurant = restaurantRepo.create({
      nom: r.nom,
      ville: r.ville,
      note: r.note,
      fraisLivraisonFcfa: r.fraisLivraisonFcfa,
      delaiLivraisonMinutes: r.delaiLivraisonMinutes,
    });
    const saved = await restaurantRepo.save(restaurant);

    for (const item of r.menu) {
      const menuItem = menuItemRepo.create({
        nom: item.nom,
        prixFcfa: item.prixFcfa,
        restaurantId: saved.id,
        disponible: true,
      });
      await menuItemRepo.save(menuItem);
    }
  }

  console.log(`${data.length} restaurants inseres.`);
  await app.close();
}

seed().catch((err) => {
  console.error('Erreur pendant le seed :', err);
  process.exit(1);
});
