import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn, UpdateDateColumn } from 'typeorm';

export type Role = 'vet' | 'technician' | 'pharmacist' | 'reception' | 'admin' | 'auditor';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  name!: string;

  @Column({ unique: true })
  email!: string;

  @Column({ nullable: true })
  phone?: string;

  @Column('simple-array')
  roles!: Role[];

  @Column({ nullable: true })
  licenseNumber?: string;

  @Column({ default: true })
  active!: boolean;

  @Column({ default: false })
  mfaEnabled!: boolean;

  @Column({ nullable: true })
  mfaSecret?: string;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
