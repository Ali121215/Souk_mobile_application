import { Column, Entity, PrimaryGeneratedColumn, CreateDateColumn } from 'typeorm';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true, nullable: true })
  telephone: string;

  @Column({ unique: true, nullable: true })
  email: string;

  @Column({ nullable: true })
  nom: string;

  @Column({ nullable: true })
  ville: string;

  @Column({ default: false })
  telephoneVerifie: boolean;

  @Column({ default: false })
  emailVerifie: boolean;

  @CreateDateColumn()
  creeLe: Date;
}
