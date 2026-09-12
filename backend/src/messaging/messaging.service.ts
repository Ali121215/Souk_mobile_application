import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Message } from './message.entity';

@Injectable()
export class MessagingService {
  constructor(
    @InjectRepository(Message) private readonly messages: Repository<Message>,
  ) {}

  findConversation(conversationId: string) {
    return this.messages.find({
      where: { conversationId },
      order: { envoyeLe: 'ASC' },
    });
  }

  send(expediteurId: string, conversationId: string, contenu: string) {
    const message = this.messages.create({ expediteurId, conversationId, contenu });
    // TODO: notifier le destinataire via WebSocket + notification push (FCM)
    return this.messages.save(message);
  }
}
