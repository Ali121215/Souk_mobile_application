import { Column, Entity, PrimaryGeneratedColumn, OneToMany } from 'typeorm';
import { MenuItem } from './menu-item.entity';

@Entity('restaurants')
export class Restaurant {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  nom: string;

  @Column()
  ville: string;

  @Column({ type: 'float', default: 0 })
  note: number;

  @Column({ nullable: true })
  fraisLivraisonFcfa: number;

  @Column({ nullable: true })
  delaiLivraisonMinutes: number;

  @OneToMany(() => MenuItem, (item) => item.restaurant)
  menu: MenuItem[];
}
