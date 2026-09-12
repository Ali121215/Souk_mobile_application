import { Column, Entity, PrimaryGeneratedColumn, OneToMany, CreateDateColumn } from 'typeorm';
import { OrderItem } from './order-item.entity';

export enum OrderStatus {
  RECUE = 'recue',
  EN_PREPARATION = 'en_preparation',
  EN_LIVRAISON = 'en_livraison',
  LIVREE = 'livree',
  ANNULEE = 'annulee',
}

@Entity('orders')
export class Order {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  userId: string;

  @Column()
  restaurantId: string;

  @Column({ type: 'enum', enum: OrderStatus, default: OrderStatus.RECUE })
  statut: OrderStatus;

  @Column('int')
  totalFcfa: number;

  @Column({ nullable: true })
  adresseLivraison: string;

  @OneToMany(() => OrderItem, (item) => item.order, { cascade: true })
  articles: OrderItem[];

  @CreateDateColumn()
  creeLe: Date;
}
