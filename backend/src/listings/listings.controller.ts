import { Body, Controller, Get, Param, Post, Query, Req, UseGuards } from '@nestjs/common';
import { ListingsService } from './listings.service';
import { CreateListingDto } from './dto/create-listing.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('listings')
export class ListingsController {
  constructor(private readonly listingsService: ListingsService) {}

  @Get()
  findAll(@Query('ville') ville?: string, @Query('categorie') categorie?: string) {
    return this.listingsService.findAll({ ville, categorie });
  }

  @UseGuards(JwtAuthGuard)
  @Get('mine/liste')
  findMine(@Req() req: any) {
    return this.listingsService.findMine(req.user.sub);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.listingsService.findOne(id);
  }

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Req() req: any, @Body() dto: CreateListingDto) {
    return this.listingsService.create(req.user.sub, dto);
  }
}
