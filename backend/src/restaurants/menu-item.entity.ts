import { Column, Entity, PrimaryGeneratedColumn, ManyToOne } from 'typeorm';
import { Restaurant } from './restaurant.entity';

@Entity('menu_items')
export class MenuItem {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  nom: string;

  @Column('int')
  prixFcfa: number;

  @Column({ default: true })
  disponible: boolean;

  @ManyToOne(() => Restaurant, (restaurant) => restaurant.menu, { onDelete: 'CASCADE' })
  restaurant: Restaurant;

  @Column()
  restaurantId: string;
}
