import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import { User } from './user.entity';

interface OtpEntry {
  code: string;
  expiresAt: number;
}

@Injectable()
export class AuthService {
  private otpStore = new Map<string, OtpEntry>();

  constructor(
    @InjectRepository(User) private readonly users: Repository<User>,
    private readonly jwtService: JwtService,
  ) {}

  private generateAndStoreOtp(key: string): string {
    const code = Math.floor(1000 + Math.random() * 9000).toString();
    const expiresAt = Date.now() + 5 * 60 * 1000;
    this.otpStore.set(key, { code, expiresAt });
    return code;
  }

  private checkOtp(key: string, code: string) {
    const entry = this.otpStore.get(key);
    if (!entry || entry.expiresAt < Date.now()) {
      throw new UnauthorizedException('Code expire, veuillez en redemander un');
    }
    if (entry.code !== code) {
      throw new UnauthorizedException('Code incorrect');
    }
    this.otpStore.delete(key);
  }

  private issueToken(user: User) {
    const token = this.jwtService.sign({ sub: user.id, telephone: user.telephone, email: user.email });
    return { user, token };
  }

  async requestOtp(telephone: string) {
    const code = this.generateAndStoreOtp(telephone);
    console.log(`[DEV] Code OTP pour ${telephone} : ${code} (valable 5 min)`);
    return { message: 'Code envoye par SMS' };
  }

  async verifyOtp(telephone: string, code: string) {
    this.checkOtp(telephone, code);
    let user = await this.users.findOne({ where: { telephone } });
    if (!user) {
      user = this.users.create({ telephone, telephoneVerifie: true });
      await this.users.save(user);
    }
    return this.issueToken(user);
  }

  async requestOtpEmail(email: string) {
    const key = `email:${email}`;
    const code = this.generateAndStoreOtp(key);
    console.log(`[DEV] Code OTP pour ${email} : ${code} (valable 5 min)`);
    return { message: 'Code envoye par email' };
  }

  async verifyOtpEmail(email: string, code: string) {
    const key = `email:${email}`;
    this.checkOtp(key, code);
    let user = await this.users.findOne({ where: { email } });
    if (!user) {
      user = this.users.create({ email, emailVerifie: true });
      await this.users.save(user);
    }
    return this.issueToken(user);
  }
}
