import { CanActivate, ExecutionContext, Injectable, ForbiddenException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class AdminGuard implements CanActivate {
  constructor(private readonly config: ConfigService) {}

  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const user = request.user;

    const adminList = (this.config.get<string>('ADMIN_IDENTIFIERS') || '')
      .split(',')
      .map((s) => s.trim())
      .filter(Boolean);

    const isAdmin = adminList.includes(user?.telephone) || adminList.includes(user?.email);

    if (!isAdmin) {
      throw new ForbiddenException("Acces reserve aux administrateurs");
    }
    return true;
  }
}
