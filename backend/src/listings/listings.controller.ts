import { Body, Controller, Get, Param, Post, Query } from '@nestjs/common';
import { ListingsService } from './listings.service';
import { CreateListingDto } from './dto/create-listing.dto';

@Controller('listings')
export class ListingsController {
  constructor(private readonly listingsService: ListingsService) {}

  @Get()
  findAll(@Query('ville') ville?: string, @Query('categorie') categorie?: string) {
    return this.listingsService.findAll({ ville, categorie });
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.listingsService.findOne(id);
  }

  @Post()
  create(@Body() dto: CreateListingDto) {
    // TODO: remplacer cet id fixe par l'utilisateur authentifié (via le futur guard JWT)
    const vendeurIdTemporaire = '00000000-0000-0000-0000-000000000000';
    return this.listingsService.create(vendeurIdTemporaire, dto);
  }
}
