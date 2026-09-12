import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Listing, ListingStatus } from './listing.entity';
import { CreateListingDto } from './dto/create-listing.dto';

@Injectable()
export class ListingsService {
  constructor(
    @InjectRepository(Listing) private readonly listings: Repository<Listing>,
  ) {}

  // Liste uniquement les annonces déjà modérées et publiées, avec filtres simples.
  async findAll(filters: { ville?: string; categorie?: string }) {
    return this.listings.find({
      where: {
        statut: ListingStatus.PUBLIEE,
        ...(filters.ville ? { ville: filters.ville } : {}),
        ...(filters.categorie ? { categorie: filters.categorie } : {}),
      },
      order: { creeLe: 'DESC' },
      take: 20, // pagination simple pour le MVP
    });
  }

  async findOne(id: string) {
    const listing = await this.listings.findOne({ where: { id } });
    if (!listing) throw new NotFoundException('Annonce introuvable');
    return listing;
  }

  // Toute nouvelle annonce part en modération avant d'être visible publiquement.
  async create(vendeurId: string, dto: CreateListingDto) {
    const listing = this.listings.create({
      ...dto,
      vendeurId,
      statut: ListingStatus.EN_ATTENTE,
    });
    return this.listings.save(listing);
  }
}
