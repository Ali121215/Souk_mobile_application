import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { JobOffer } from './job-offer.entity';
import { JobApplication } from './job-application.entity';
import { JobsService } from './jobs.service';
import { JobsController } from './jobs.controller';

@Module({
  imports: [TypeOrmModule.forFeature([JobOffer, JobApplication])],
  controllers: [JobsController],
  providers: [JobsService],
})
export class JobsModule {}
