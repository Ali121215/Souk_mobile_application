import { Column, Entity, PrimaryGeneratedColumn, CreateDateColumn } from 'typeorm';

@Entity('messages')
export class Message {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  conversationId: string;

  @Column()
  expediteurId: string;

  @Column('text')
  contenu: string;

  @Column({ default: false })
  lu: boolean;

  @CreateDateColumn()
  envoyeLe: Date;
}
