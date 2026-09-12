import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { Restaurant } from './restaurant.entity';
import { MenuItem } from './menu-item.entity';
import { Order, OrderStatus } from './order.entity';
import { OrderItem } from './order-item.entity';
import { CreateOrderDto } from './dto/create-order.dto';

@Injectable()
export class RestaurantsService {
  constructor(
    @InjectRepository(Restaurant) private readonly restaurants: Repository<Restaurant>,
    @InjectRepository(MenuItem) private readonly menuItems: Repository<MenuItem>,
    @InjectRepository(Order) private readonly orders: Repository<Order>,
  ) {}

  findAll(ville?: string) {
    return this.restaurants.find({ where: ville ? { ville } : {} });
  }

  async findMenu(restaurantId: string) {
    const restaurant = await this.restaurants.findOne({ where: { id: restaurantId } });
    if (!restaurant) throw new NotFoundException('Restaurant introuvable');
    return this.menuItems.find({ where: { restaurantId, disponible: true } });
  }

  // Calcule le total côté serveur à partir des vrais prix en base — jamais faire confiance au prix envoyé par le client.
  async createOrder(userId: string, dto: CreateOrderDto) {
    const ids = dto.articles.map((a) => a.menuItemId);
    const items = await this.menuItems.find({ where: { id: In(ids) } });

    const order = this.orders.create({
      userId,
      restaurantId: dto.restaurantId,
      adresseLivraison: dto.adresseLivraison,
      statut: OrderStatus.RECUE,
      totalFcfa: 0,
      articles: [],
    });

    let total = 0;
    order.articles = dto.articles.map((a) => {
      const item = items.find((i) => i.id === a.menuItemId);
      if (!item) throw new NotFoundException(`Article ${a.menuItemId} introuvable`);
      total += item.prixFcfa * a.quantite;
      const orderItem = new OrderItem();
      orderItem.menuItemId = item.id;
      orderItem.quantite = a.quantite;
      orderItem.prixUnitaireFcfa = item.prixFcfa;
      return orderItem;
    });
    order.totalFcfa = total;

    return this.orders.save(order);
  }

  async updateStatus(orderId: string, statut: OrderStatus) {
    await this.orders.update(orderId, { statut });
    return this.orders.findOne({ where: { id: orderId }, relations: ['articles'] });
  }
}
