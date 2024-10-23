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
