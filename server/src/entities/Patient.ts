import { Column, CreateDateColumn, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from 'typeorm';
import { Encounter } from './Encounter.js';
import { User } from './User.js';

@Entity('patients')
export class Patient {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  name!: string;

  @Column()
  species!: string;

  @Column({ nullable: true })
  breed?: string;

  @Column({ nullable: true })
  sex?: string;

  @Column({ nullable: true })
  weightKg?: number;

  @Column('simple-array', { default: '' })
  allergies!: string[];

  @ManyToOne(() => User, { nullable: true })
  primaryVeterinarian?: User;

  @OneToMany('Encounter', 'patient')
  encounters?: Encounter[];

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
