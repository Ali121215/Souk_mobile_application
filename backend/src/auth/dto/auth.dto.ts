import { IsPhoneNumber, IsString, Length } from 'class-validator';

export class RequestOtpDto {
  @IsPhoneNumber(undefined, { message: 'Numéro de téléphone invalide' })
  telephone: string;
}

export class VerifyOtpDto {
  @IsPhoneNumber(undefined, { message: 'Numéro de téléphone invalide' })
  telephone: string;

  @IsString()
  @Length(4, 6)
  code: string;
}
