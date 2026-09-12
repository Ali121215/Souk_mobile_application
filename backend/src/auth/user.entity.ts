import { Column, Entity, PrimaryGeneratedColumn, CreateDateColumn } from 'typeorm';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  telephone: string; // format international, ex: +23566XXXXXX

  @Column({ nullable: true })
  nom: string;

  @Column({ nullable: true })
  ville: string;

  @Column({ default: false })
  telephoneVerifie: boolean;

  @CreateDateColumn()
  creeLe: Date;
}
