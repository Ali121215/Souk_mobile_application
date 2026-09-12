import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';

import { AuthModule } from './auth/auth.module';
import { ListingsModule } from './listings/listings.module';
import { RestaurantsModule } from './restaurants/restaurants.module';
import { JobsModule } from './jobs/jobs.module';
import { MessagingModule } from './messaging/messaging.module';
import { HealthController } from './common/health.controller';

@Module({
  imports: [
    // Charge le fichier .env et rend les variables disponibles partout via ConfigService
    ConfigModule.forRoot({ isGlobal: true }),

    // Connexion PostgreSQL — synchronize:true est pratique en dev seulement,
    // à remplacer par de vraies migrations avant la mise en production.
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST || 'localhost',
      port: parseInt(process.env.DB_PORT || '5432', 10),
      username: process.env.DB_USER || 'souk',
      password: process.env.DB_PASSWORD || 'souk_dev_password',
      database: process.env.DB_NAME || 'souk_db',
      autoLoadEntities: true,
      synchronize: process.env.NODE_ENV !== 'production',
    }),

    // Un module par domaine métier — reflète le diagramme d'architecture validé
    AuthModule,
    ListingsModule,
    RestaurantsModule,
    JobsModule,
    MessagingModule,
  ],
  controllers: [HealthController],
})
export class AppModule {}
