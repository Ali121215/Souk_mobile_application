import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Listing, ListingStatus } from './listing.entity';
import { CreateListingDto } from './dto/create-listing.dto';
import { User } from '../auth/user.entity';

@Injectable()
export class ListingsService {
  constructor(
    @InjectRepository(Listing) private readonly listings: Repository<Listing>,
    @InjectRepository(User) private readonly users: Repository<User>,
  ) {}

  async findAll(filters: { ville?: string; categorie?: string }) {
    return this.listings.find({
      where: {
        statut: ListingStatus.PUBLIEE,
        ...(filters.ville ? { ville: filters.ville } : {}),
        ...(filters.categorie ? { categorie: filters.categorie } : {}),
      },
      order: { creeLe: 'DESC' },
      take: 20,
    });
  }

  async findMine(vendeurId: string) {
    return this.listings.find({
      where: { vendeurId },
      order: { creeLe: 'DESC' },
    });
  }

  async findOne(id: string) {
    const listing = await this.listings.findOne({ where: { id } });
    if (!listing) throw new NotFoundException('Annonce introuvable');

    const vendeur = await this.users.findOne({ where: { id: listing.vendeurId } });

    return {
      ...listing,
      vendeurTelephone: vendeur?.telephone ?? null,
      vendeurNom: vendeur?.nom ?? 'Vendeur Souk',
    };
  }

  async create(vendeurId: string, dto: CreateListingDto) {
    const listing = this.listings.create({
      ...dto,
      vendeurId,
      statut: ListingStatus.EN_ATTENTE,
    });
    return this.listings.save(listing);
  }

  async findPending() {
    return this.listings.find({
      where: { statut: ListingStatus.EN_ATTENTE },
      order: { creeLe: 'ASC' },
    });
  }

  async approve(id: string) {
    await this.findOne(id);
    await this.listings.update(id, { statut: ListingStatus.PUBLIEE });
    return this.listings.findOne({ where: { id } });
  }

  async reject(id: string) {
    await this.findOne(id);
    await this.listings.update(id, { statut: ListingStatus.REFUSEE });
    return this.listings.findOne({ where: { id } });
  }
}
