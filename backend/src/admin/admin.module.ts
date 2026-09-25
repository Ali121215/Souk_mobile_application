import { Module } from '@nestjs/common';
import { AdminController } from './admin.controller';
import { AdminGuard } from './admin.guard';
import { AuthModule } from '../auth/auth.module';
import { ListingsModule } from '../listings/listings.module';

@Module({
  imports: [AuthModule, ListingsModule],
  controllers: [AdminController],
  providers: [AdminGuard],
})
export class AdminModule {}
