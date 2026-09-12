import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './user.entity';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User) private readonly users: Repository<User>,
  ) {}

  /**
   * Génère un code OTP et l'envoie par SMS.
   * TODO: brancher un vrai fournisseur SMS tchadien/régional ici.
   */
  async requestOtp(telephone: string) {
    const code = Math.floor(1000 + Math.random() * 9000).toString();
    // TODO: stocker le code (Redis, expiration 5 min) + appeler le fournisseur SMS
    console.log(`[DEV] Code OTP pour ${telephone} : ${code}`);
    return { message: 'Code envoyé par SMS' };
  }

  /**
   * Vérifie le code OTP et crée l'utilisateur s'il n'existe pas encore.
   */
  async verifyOtp(telephone: string, code: string) {
    // TODO: vérifier le vrai code stocké au lieu de l'accepter systématiquement
    let user = await this.users.findOne({ where: { telephone } });
    if (!user) {
      user = this.users.create({ telephone, telephoneVerifie: true });
      await this.users.save(user);
    }
    // TODO: générer un vrai JWT signé avec JWT_SECRET
    return { user, token: 'jwt-a-generer' };
  }
}
