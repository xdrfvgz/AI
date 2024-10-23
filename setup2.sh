```bash
#!/bin/bash

# Modelle erstellen
mkdir -p app/src/main/java/com/example/multiai/data/api/models
cat > app/src/main/java/com/example/multiai/data/api/models/ChatRequest.kt << 'EOL'
package com.example.multiai.data.api.models

data class ChatRequest(
    val service: String,
    val message: String,
    val config: Map<String, Any>? = null,
    val systemPrompt: String? = null
)
EOL

cat > app/src/main/java/com/example/multiai/data/api/models/ChatResponse.kt << 'EOL'
package com.example.multiai.data.api.models

data class ChatResponse(
    val response: String,
    val service: String
)

data class ServicesResponse(
    val services: List<String>
)
EOL

# Datenbank-Entities
mkdir -p app/src/main/java/com/example/multiai/data/db/entities
cat > app/src/main/java/com/example/multiai/data/db/entities/Message.kt << 'EOL'
package com.example.multiai.data.db.entities

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "messages")
data class Message(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val content: String,
    val isFromUser: Boolean,
    val timestamp: Long,
    val service: String? = null
)
EOL

# Repository
cat > app/src/main/java/com/example/multiai/data/repository/ChatRepository.kt << 'EOL'
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
EOL

# Chat Activity und ViewModel
mkdir -p app/src/main/java/com/example/multiai/ui/chat
cat > app/src/main/java/com/example/multiai/ui/chat/ChatActivity.kt << 'EOL'
# Inhalt wie vorher gezeigt in ChatActivity.kt
EOL

cat > app/src/main/java/com/example/multiai/ui/chat/ChatViewModel.kt << 'EOL'
# Inhalt wie vorher gezeigt in ChatViewModel.kt
EOL

# Adapter
mkdir -p app/src/main/java/com/example/multiai/ui/chat/adapters
cat > app/src/main/java/com/example/multiai/ui/chat/adapters/ChatAdapter.kt << 'EOL'
# Inhalt wie vorher gezeigt in ChatAdapter.kt
EOL

# Ressourcen
mkdir -p app/src/main/res/layout
cat > app/src/main/res/layout/activity_chat.xml << 'EOL'
# Layout wie vorher gezeigt
EOL

cat > app/src/main/res/layout/item_message.xml << 'EOL'
# Layout wie vorher gezeigt
EOL

mkdir -p app/src/main/res/values
cat > app/src/main/res/values/colors.xml << 'EOL'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="primary">#1976D2</color>
    <color name="primary_dark">#1565C0</color>
    <color name="primary_light">#BBDEFB</color>
    <color name="accent">#FF4081</color>
    <color name="received_message_background">#F5F5F5</color>
    <color name="received_message_text">#000000</color>
    <color name="sent_message_text">#FFFFFF</color>
</resources>
EOL

cat > app/src/main/res/values/strings.xml << 'EOL'
<resources>
    <string name="app_name">MultiAI</string>
    <string name="message_hint">Nachricht eingeben...</string>
    <string name="send">Senden</string>
    <string name="error_no_service">Kein Service ausgewählt</string>
    <string name="error_sending_message">Fehler beim Senden der Nachricht</string>
</resources>
EOL

# Datenbank
cat > app/src/main/java/com/example/multiai/data/db/ChatDatabase.kt << 'EOL'
package com.example.multiai.data.db

import androidx.room.Database
import androidx.room.RoomDatabase
import com.example.multiai.data.db.entities.Message

@Database(entities = [Message::class], version = 1)
abstract class ChatDatabase : RoomDatabase() {
    abstract fun messageDao(): MessageDao
}

@Dao
interface MessageDao {
    @Query("SELECT * FROM messages ORDER BY timestamp ASC")
    fun getAllMessages(): Flow<List<Message>>

    @Insert
    suspend fun insert(message: Message)
}
EOL

echo "Alle fehlenden Dateien wurden erstellt!"
```
