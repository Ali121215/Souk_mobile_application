import { Column, Entity, PrimaryGeneratedColumn, CreateDateColumn } from 'typeorm';

export enum ListingStatus {
  EN_ATTENTE = 'en_attente', // en attente de modération
  PUBLIEE = 'publiee',
  REFUSEE = 'refusee',
  VENDUE = 'vendue',
}

@Entity('listings')
export class Listing {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  titre: string;

  @Column('text', { nullable: true })
  description: string;

  @Column()
  categorie: string; // immobilier, vehicules, materiel, electronique, mode, services

  @Column('int')
  prixFcfa: number;

  @Column()
  ville: string;

  @Column({ type: 'float', nullable: true })
  latitude: number;

  @Column({ type: 'float', nullable: true })
  longitude: number;

  @Column({ type: 'enum', enum: ListingStatus, default: ListingStatus.EN_ATTENTE })
  statut: ListingStatus;

  @Column('uuid')
  vendeurId: string;

  @CreateDateColumn()
  creeLe: Date;
}
