import {
  Column,
  CreateDateColumn,
  Entity,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn
} from 'typeorm';
import { Patient } from './Patient.js';
import { Order } from './Order.js';
import { User } from './User.js';

@Entity('encounters')
export class Encounter {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @ManyToOne('Patient', 'encounters')
  patient!: Patient;

  @ManyToOne(() => User, { nullable: true })
  assignedTeamMember?: User;

  @Column()
  reason!: string;

  @Column({ default: 'open' })
  status!: 'open' | 'in-progress' | 'closed';

  @Column({ nullable: true })
  location?: string;

  @Column('jsonb', { default: {} })
  vitals!: Record<string, unknown>;

  @OneToMany('Order', 'encounter')
  orders?: Order[];

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
