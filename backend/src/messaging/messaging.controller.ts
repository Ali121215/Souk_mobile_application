import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { MessagingService } from './messaging.service';
import { SendMessageDto } from './dto/send-message.dto';

@Controller('messages')
export class MessagingController {
  constructor(private readonly messagingService: MessagingService) {}

  @Get('conversation/:id')
  findConversation(@Param('id') conversationId: string) {
    return this.messagingService.findConversation(conversationId);
  }

  @Post()
  send(@Body() dto: SendMessageDto) {
    // TODO: remplacer par l'utilisateur authentifié
    const expediteurIdTemporaire = '00000000-0000-0000-0000-000000000000';
    return this.messagingService.send(expediteurIdTemporaire, dto.conversationId, dto.contenu);
  }
}
