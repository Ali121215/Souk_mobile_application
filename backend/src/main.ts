import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.enableCors();

  // Validation automatique des DTO sur chaque route
  app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));

  // Préfixe commun pour toutes les routes : /api/v1/...
  app.setGlobalPrefix('api/v1');

  const port = process.env.PORT || 3000;
  await app.listen(port);
  console.log(`Souk API démarrée sur http://localhost:${port}/api/v1`);
}
bootstrap();
