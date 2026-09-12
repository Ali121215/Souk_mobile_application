import { Body, Controller, Get, Param, Post, Query } from '@nestjs/common';
import { JobsService } from './jobs.service';
import { CreateJobOfferDto, ApplyJobDto } from './dto/job.dto';

@Controller('jobs')
export class JobsController {
  constructor(private readonly jobsService: JobsService) {}

  @Get()
  findAll(@Query('ville') ville?: string, @Query('secteur') secteur?: string) {
    return this.jobsService.findAll({ ville, secteur });
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.jobsService.findOne(id);
  }

  @Post()
  create(@Body() dto: CreateJobOfferDto) {
    // TODO: remplacer par le recruteur authentifié
    const recruteurIdTemporaire = '00000000-0000-0000-0000-000000000000';
    return this.jobsService.create(recruteurIdTemporaire, dto);
  }

  @Post(':id/postuler')
  apply(@Param('id') id: string, @Body() dto: ApplyJobDto) {
    // TODO: remplacer par le candidat authentifié
    const candidatIdTemporaire = '00000000-0000-0000-0000-000000000000';
    return this.jobsService.apply(id, candidatIdTemporaire, dto);
  }
}
