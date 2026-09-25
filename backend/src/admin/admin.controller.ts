import { Controller, Get, Param, Patch, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { AdminGuard } from './admin.guard';
import { ListingsService } from '../listings/listings.service';

@UseGuards(JwtAuthGuard, AdminGuard)
@Controller('admin')
export class AdminController {
  constructor(private readonly listingsService: ListingsService) {}

  @Get('listings/pending')
  findPendingListings() {
    return this.listingsService.findPending();
  }

  @Patch('listings/:id/approve')
  approveListing(@Param('id') id: string) {
    return this.listingsService.approve(id);
  }

  @Patch('listings/:id/reject')
  rejectListing(@Param('id') id: string) {
    return this.listingsService.reject(id);
  }
}
