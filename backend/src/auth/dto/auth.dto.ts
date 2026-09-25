import { IsPhoneNumber, IsString, Length, IsEmail } from 'class-validator';

export class RequestOtpDto {
  @IsPhoneNumber(undefined, { message: 'Numero de telephone invalide' })
  telephone: string;
}

export class VerifyOtpDto {
  @IsPhoneNumber(undefined, { message: 'Numero de telephone invalide' })
  telephone: string;

  @IsString()
  @Length(4, 6)
  code: string;
}

export class RequestEmailOtpDto {
  @IsEmail(undefined, { message: 'Adresse email invalide' })
  email: string;
}

export class VerifyEmailOtpDto {
  @IsEmail(undefined, { message: 'Adresse email invalide' })
  email: string;

  @IsString()
  @Length(4, 6)
  code: string;
}