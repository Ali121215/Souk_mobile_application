import { Body, Controller, Get, Param, Patch, Post, Query } from '@nestjs/common';
import { RestaurantsService } from './restaurants.service';
import { CreateOrderDto } from './dto/create-order.dto';
import { OrderStatus } from './order.entity';

@Controller()
export class RestaurantsController {
  constructor(private readonly restaurantsService: RestaurantsService) {}

  @Get('restaurants')
  findAll(@Query('ville') ville?: string) {
    return this.restaurantsService.findAll(ville);
  }

  @Get('restaurants/:id/menu')
  findMenu(@Param('id') id: string) {
    return this.restaurantsService.findMenu(id);
  }

  @Post('orders')
  createOrder(@Body() dto: CreateOrderDto) {
    // TODO: remplacer par l'utilisateur authentifié
    const userIdTemporaire = '00000000-0000-0000-0000-000000000000';
    return this.restaurantsService.createOrder(userIdTemporaire, dto);
  }

  @Patch('orders/:id/statut')
  updateStatus(@Param('id') id: string, @Body('statut') statut: OrderStatus) {
    return this.restaurantsService.updateStatus(id, statut);
  }
}
