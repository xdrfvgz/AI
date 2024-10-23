package com.example.multiai.data.repository

import com.example.multiai.data.api.MultiAIService
import com.example.multiai.data.db.ChatDatabase
import com.example.multiai.data.api.models.ChatRequest
import com.example.multiai.data.db.entities.Message
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

class ChatRepository @Inject constructor(
    private val api: MultiAIService,
    private val db: ChatDatabase
) {
    fun getAllMessages(): Flow<List<Message>> = db.messageDao().getAllMessages()

    suspend fun saveMessage(message: Message) = db.messageDao().insert(message)

    suspend fun sendMessage(service: String, content: String): ChatResponse {
        return api.sendMessage(ChatRequest(service = service, message = content))
    }

    suspend fun getAvailableServices(): List<String> {
        return api.getServices().services
    }

    suspend fun getServiceConfig(service: String): Map<String, Any> {
        return api.getServiceConfig(service)
    }
}
