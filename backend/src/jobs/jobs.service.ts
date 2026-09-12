import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JobOffer } from './job-offer.entity';
import { JobApplication } from './job-application.entity';
import { CreateJobOfferDto, ApplyJobDto } from './dto/job.dto';

@Injectable()
export class JobsService {
  constructor(
    @InjectRepository(JobOffer) private readonly offers: Repository<JobOffer>,
    @InjectRepository(JobApplication) private readonly applications: Repository<JobApplication>,
  ) {}

  findAll(filters: { ville?: string; secteur?: string }) {
    return this.offers.find({
      where: {
        active: true,
        ...(filters.ville ? { ville: filters.ville } : {}),
        ...(filters.secteur ? { secteur: filters.secteur } : {}),
      },
      order: { creeLe: 'DESC' },
      take: 20,
    });
  }

  async findOne(id: string) {
    const offer = await this.offers.findOne({ where: { id } });
    if (!offer) throw new NotFoundException('Offre introuvable');
    return offer;
  }

  create(recruteurId: string, dto: CreateJobOfferDto) {
    const offer = this.offers.create({ ...dto, recruteurId });
    return this.offers.save(offer);
  }

  async apply(jobOfferId: string, candidatId: string, dto: ApplyJobDto) {
    await this.findOne(jobOfferId); // vérifie que l'offre existe
    const application = this.applications.create({
      jobOfferId,
      candidatId,
      messageMotivation: dto.messageMotivation,
    });
    return this.applications.save(application);
  }
}
