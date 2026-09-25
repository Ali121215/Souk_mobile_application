import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Listing } from './listing.entity';
import { ListingsService } from './listings.service';
import { ListingsController } from './listings.controller';
import { AuthModule } from '../auth/auth.module';
import { User } from '../auth/user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Listing, User]), AuthModule],
  controllers: [ListingsController],
  providers: [ListingsService],
  exports: [ListingsService],
})
export class ListingsModule {}
