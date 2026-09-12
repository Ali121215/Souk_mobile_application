import { IsIn, IsInt, IsNumber, IsOptional, IsString, Min } from 'class-validator';

const CATEGORIES = ['immobilier', 'vehicules', 'materiel', 'electronique', 'mode', 'services'];

export class CreateListingDto {
  @IsString()
  titre: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsIn(CATEGORIES, { message: `La catégorie doit être l'une de : ${CATEGORIES.join(', ')}` })
  categorie: string;

  @IsInt()
  @Min(0)
  prixFcfa: number;

  @IsString()
  ville: string;

  @IsOptional()
  @IsNumber()
  latitude?: number;

  @IsOptional()
  @IsNumber()
  longitude?: number;
}
