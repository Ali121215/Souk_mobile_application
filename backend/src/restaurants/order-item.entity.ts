import { Column, Entity, PrimaryGeneratedColumn, ManyToOne } from 'typeorm';
import { Order } from './order.entity';

@Entity('order_items')
export class OrderItem {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  menuItemId: string;

  @Column('int')
  quantite: number;

  @Column('int')
  prixUnitaireFcfa: number;

  @ManyToOne(() => Order, (order) => order.articles, { onDelete: 'CASCADE' })
  order: Order;

  @Column()
  orderId: string;
}
