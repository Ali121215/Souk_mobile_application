import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RequestOtpDto, VerifyOtpDto, RequestEmailOtpDto, VerifyEmailOtpDto } from './dto/auth.dto';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('request-otp')
  requestOtp(@Body() dto: RequestOtpDto) {
    return this.authService.requestOtp(dto.telephone);
  }

  @Post('verify-otp')
  verifyOtp(@Body() dto: VerifyOtpDto) {
    return this.authService.verifyOtp(dto.telephone, dto.code);
  }

  @Post('email/request-otp')
  requestOtpEmail(@Body() dto: RequestEmailOtpDto) {
    return this.authService.requestOtpEmail(dto.email);
  }

  @Post('email/verify-otp')
  verifyOtpEmail(@Body() dto: VerifyEmailOtpDto) {
    return this.authService.verifyOtpEmail(dto.email, dto.code);
  }
}
