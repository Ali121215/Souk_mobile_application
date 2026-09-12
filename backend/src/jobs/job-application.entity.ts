import { Column, Entity, PrimaryGeneratedColumn, CreateDateColumn } from 'typeorm';

@Entity('job_applications')
export class JobApplication {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  jobOfferId: string;

  @Column()
  candidatId: string;

  @Column({ nullable: true })
  messageMotivation: string;

  @CreateDateColumn()
  postuleLe: Date;
}
