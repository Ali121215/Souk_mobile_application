import { Body, Controller, Get, Param, Patch, Post, Query, Req, UseGuards } from '@nestjs/common';
import { RestaurantsService } from './restaurants.service';
import { CreateOrderDto } from './dto/create-order.dto';
import { OrderStatus } from './order.entity';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

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

  @UseGuards(JwtAuthGuard)
  @Post('orders')
  createOrder(@Req() req: any, @Body() dto: CreateOrderDto) {
    return this.restaurantsService.createOrder(req.user.sub, dto);
  }

  @Patch('orders/:id/statut')
  updateStatus(@Param('id') id: string, @Body('statut') statut: OrderStatus) {
    return this.restaurantsService.updateStatus(id, statut);
  }

  @UseGuards(JwtAuthGuard)
  @Get('orders/mine')
  findMyOrders(@Req() req: any) {
    return this.restaurantsService.findMyOrders(req.user.sub);
  }
}
