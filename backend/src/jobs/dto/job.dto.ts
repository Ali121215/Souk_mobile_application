import { IsEnum, IsInt, IsOptional, IsString, Min } from 'class-validator';
import { ContractType } from '../job-offer.entity';

export class CreateJobOfferDto {
  @IsString()
  titre: string;

  @IsString()
  description: string;

  @IsString()
  entreprise: string;

  @IsString()
  ville: string;

  @IsString()
  secteur: string;

  @IsEnum(ContractType)
  typeContrat: ContractType;

  @IsOptional()
  @IsInt()
  @Min(0)
  salaireFcfa?: number;
}

export class ApplyJobDto {
  @IsOptional()
  @IsString()
  messageMotivation?: string;
}
