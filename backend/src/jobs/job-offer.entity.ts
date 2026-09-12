import { Column, Entity, PrimaryGeneratedColumn, CreateDateColumn } from 'typeorm';

export enum ContractType {
  CDI = 'cdi',
  CDD = 'cdd',
  STAGE = 'stage',
  PETIT_BOULOT = 'petit_boulot',
}

@Entity('job_offers')
export class JobOffer {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  titre: string;

  @Column('text')
  description: string;

  @Column()
  entreprise: string;

  @Column()
  ville: string;

  @Column()
  secteur: string; // ex: commerce, BTP, informatique, restauration...

  @Column({ type: 'enum', enum: ContractType })
  typeContrat: ContractType;

  @Column({ nullable: true })
  salaireFcfa: number;

  @Column()
  recruteurId: string;

  @Column({ default: true })
  active: boolean;

  @CreateDateColumn()
  creeLe: Date;
}
