import { Column, CreateDateColumn, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from 'typeorm';
import { Encounter } from './Encounter.js';
import { User } from './User.js';
import { MedicationAdministrationRecord } from './MedicationAdministrationRecord.js';

@Entity('orders')
export class Order {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @ManyToOne('Encounter', 'orders')
  encounter!: Encounter;

  @ManyToOne(() => User)
  prescriber!: User;

  @Column()
  medication!: string;

  @Column()
  dose!: string;

  @Column({ nullable: true })
  route?: string;

  @Column({ default: 'draft' })
  status!: 'draft' | 'pending approval' | 'active' | 'held' | 'completed' | 'cancelled';

  @Column('jsonb', { default: {} })
  schedule!: Record<string, unknown>;

  @Column({ nullable: true })
  rationale?: string;

  @OneToMany('MedicationAdministrationRecord', 'order')
  marEvents?: MedicationAdministrationRecord[];

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
