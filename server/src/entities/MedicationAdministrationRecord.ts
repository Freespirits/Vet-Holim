import { Column, CreateDateColumn, Entity, ManyToOne, PrimaryGeneratedColumn, UpdateDateColumn } from 'typeorm';
import { Order } from './Order.js';
import { User } from './User.js';

@Entity('medication_administration_records')
export class MedicationAdministrationRecord {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @ManyToOne(() => Order, (order) => order.marEvents)
  order!: Order;

  @ManyToOne(() => User)
  administeredBy!: User;

  @Column()
  doseGiven!: string;

  @Column({ nullable: true })
  site?: string;

  @Column({ nullable: true })
  reason?: string;

  @Column({ default: false })
  overrideRequired!: boolean;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
