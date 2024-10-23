#!/bin/bash

# Projektname und Package
PROJECT_NAME="MultiAI"
PACKAGE_PATH="app/src/main/java/com/example/multiai"
RES_PATH="app/src/main/res"

# Erstelle Verzeichnisstruktur
mkdir -p "$PACKAGE_PATH"/{data/{api/models,db/entities,repository},ui/chat/adapters,di}
mkdir -p "$RES_PATH"/{layout,drawable,values,menu}

# 1. build.gradle (app)
cat > app/build.gradle << 'EOL'
plugins {
    id 'com.android.application'
    id 'kotlin-android'
    id 'kotlin-kapt'
    id 'dagger.hilt.android.plugin'
}

android {
    namespace 'com.example.multiai'
    compileSdk 34

    defaultConfig {
        applicationId "com.example.multiai"
        minSdk 24
        targetSdk 34
        versionCode 1
        versionName "1.0"
    }

    buildFeatures {
        viewBinding true
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = '17'
    }
}

dependencies {
    implementation 'androidx.core:core-ktx:1.12.0'
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.11.0'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    
    // ViewModel & LiveData
    implementation 'androidx.lifecycle:lifecycle-viewmodel-ktx:2.7.0'
    implementation 'androidx.lifecycle:lifecycle-livedata-ktx:2.7.0'
    implementation 'androidx.activity:activity-ktx:1.8.2'
    
    // Coroutines
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3'
    
    // Networking
    implementation 'com.squareup.retrofit2:retrofit:2.9.0'
    implementation 'com.squareup.retrofit2:converter-gson:2.9.0'
    implementation 'com.squareup.okhttp3:logging-interceptor:4.11.0'
    
    // Dependency Injection
    implementation 'com.google.dagger:hilt-android:2.48'
    kapt 'com.google.dagger:hilt-compiler:2.48'
    
    // Room Database
    implementation 'androidx.room:room-runtime:2.6.1'
    implementation 'androidx.room:room-ktx:2.6.1'
    kapt 'androidx.room:room-compiler:2.6.1'
    
    // Markdown
    implementation 'io.noties.markwon:core:4.6.2'
}
EOL

# 2. Layout-Dateien
cat > "$RES_PATH/layout/activity_chat.xml" << 'EOL'
<?xml version="1.0" encoding="utf-8"?>
<androidx.coordinatorlayout.widget.CoordinatorLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <com.google.android.material.appbar.AppBarLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content">

        <com.google.android.material.appbar.MaterialToolbar
            android:id="@+id/toolbar"
            android:layout_width="match_parent"
            android:layout_height="?attr/actionBarSize"
            android:background="?attr/colorPrimary"
            app:title="@string/app_name"
            android:theme="@style/ThemeOverlay.MaterialComponents.Dark.ActionBar"/>

        <com.google.android.material.chip.ChipGroup
            android:id="@+id/serviceChips"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:padding="8dp"
            app:singleSelection="true"
            android:background="?attr/colorSurface"/>

    </com.google.android.material.appbar.AppBarLayout>

    <androidx.recyclerview.widget.RecyclerView
        android:id="@+id/chatRecyclerView"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:clipToPadding="false"
        android:padding="8dp"
        app:layout_behavior="@string/appbar_scrolling_view_behavior"/>

    <com.google.android.material.card.MaterialCardView
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_gravity="bottom"
        android:layout_margin="8dp"
        app:cardElevation="4dp">

        <LinearLayout
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:orientation="horizontal"
            android:padding="8dp">

            <com.google.android.material.textfield.TextInputLayout
                android:id="@+id/messageInputLayout"
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:layout_weight="1"
                android:layout_marginEnd="8dp"
                style="@style/Widget.MaterialComponents.TextInputLayout.OutlinedBox">

                <com.google.android.material.textfield.TextInputEditText
                    android:id="@+id/messageInput"
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:hint="@string/message_hint"
                    android:inputType="textMultiLine"
                    android:maxLines="4"/>

            </com.google.android.material.textfield.TextInputLayout>

            <com.google.android.material.button.MaterialButton
                android:id="@+id/sendButton"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_gravity="bottom"
                app:icon="@drawable/ic_send"/>

        </LinearLayout>

    </com.google.android.material.card.MaterialCardView>

</androidx.coordinatorlayout.widget.CoordinatorLayout>
EOL

cat > "$RES_PATH/layout/item_message.xml" << 'EOL'
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:orientation="vertical"
    android:padding="4dp">

    <com.google.android.material.card.MaterialCardView
        android:id="@+id/messageCard"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_marginStart="48dp"
        android:layout_marginEnd="8dp"
        android:layout_gravity="end"
        app:cardBackgroundColor="?attr/colorPrimary"
        app:cardCornerRadius="12dp"
        app:cardElevation="2dp">

        <TextView
            android:id="@+id/messageText"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:padding="12dp"
            android:textColor="?attr/colorOnPrimary"
            android:textSize="16sp"/>

    </com.google.android.material.card.MaterialCardView>

</LinearLayout>
EOL

# 3. DI Module
cat > "$PACKAGE_PATH/di/NetworkModule.kt" << 'EOL'
package com.example.multiai.di

import com.example.multiai.data.api.MultiAIService
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object NetworkModule {

    @Provides
    @Singleton
    fun provideOkHttpClient(): OkHttpClient {
        return OkHttpClient.Builder()
            .addInterceptor(HttpLoggingInterceptor().apply {
                level = HttpLoggingInterceptor.Level.BODY
            })
            .build()
    }

    @Provides
    @Singleton
    fun provideRetrofit(okHttpClient: OkHttpClient): Retrofit {
        return Retrofit.Builder()
            .baseUrl("http://your-server-url/") // TODO: Update with your server URL
            .client(okHttpClient)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
    }

    @Provides
    @Singleton
    fun provideMultiAIService(retrofit: Retrofit): MultiAIService {
        return retrofit.create(MultiAIService::class.java)
    }
}
EOL

cat > "$PACKAGE_PATH/di/DatabaseModule.kt" << 'EOL'
package com.example.multiai.di

import android.content.Context
import androidx.room.Room
import com.example.multiai.data.db.ChatDatabase
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object DatabaseModule {

    @Provides
    @Singleton
    fun provideChatDatabase(
        @ApplicationContext context: Context
    ): ChatDatabase {
        return Room.databaseBuilder(
            context,
            ChatDatabase::class.java,
            "chat_database"
        ).build()
    }

    @Provides
    fun provideMessageDao(database: ChatDatabase) = database.messageDao()
}
EOL

# 4. ChatActivity mit vollständiger Implementierung
cat > "$PACKAGE_PATH/ui/chat/ChatActivity.kt" << 'EOL'
package com.example.multiai.ui.chat

import android.os.Bundle
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.multiai.databinding.ActivityChatBinding
import com.example.multiai.ui.chat.adapters.ChatAdapter
import com.google.android.material.chip.Chip
import com.google.android.material.snackbar.Snackbar
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.launch

@AndroidEntryPoint
class ChatActivity : AppCompatActivity() {

    private lateinit var binding: ActivityChatBinding
    private val viewModel: ChatViewModel by viewModels()
    private val chatAdapter = ChatAdapter()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityChatBinding.inflate(layoutInflater)
        setContentView(binding.root)

        setupUI()
        observeViewModel()
    }

    private fun setupUI() {
        binding.apply {
            // RecyclerView setup
            chatRecyclerView.apply {
                adapter = chatAdapter
                layoutManager = LinearLayoutManager(context).apply {
                    stackFromEnd = true
                }
            }

            // Send button
            sendButton.setOnClickListener {
                val message = messageInput.text?.toString()
                if (!message.isNullOrBlank()) {
                    viewModel.sendMessage(message)
                    messageInput.text?.clear()
                }
            }
        }
    }

    private fun observeViewModel() {
        // Observe available services
        viewModel.availableServices.observe(this) { services ->
            binding.serviceChips.removeAllViews()
            services.forEach { service ->
                val chip = Chip(this).apply {
                    text = service
                    isCheckable = true
                    setOnCheckedChangeListener { _, isChecked ->
                        if (isChecked) viewModel.setCurrentService(service)
                    }
                }
                binding.serviceChips.addView(chip)
            }
        }

        // Observe messages
        viewModel.messages.observe(this) { messages ->
            chatAdapter.submitList(messages) {
                binding.chatRecyclerView.smoothScrollToPosition(messages.size - 1)
            }
        }

        // Observe UI state
        lifecycleScope.launch {
            viewModel.uiState.collectLatest { state ->
                when (state) {
                    is ChatViewModel.UiState.Error -> {
                        Snackbar.make(binding.root, state.message, Snackbar.LENGTH_LONG).show()
                    }
                    is ChatViewModel.UiState.Loading -> {
                        binding.sendButton.isEnabled = false
                    }
                    is ChatViewModel.UiState.Success -> {
                        binding.sendButton.isEnabled = true
                    }
                }
            }
        }
    }
}
EOL

# Weitere Dateien...
# (Füge hier die restlichen Dateien hinzu, wie ChatViewModel.kt, ChatAdapter.kt etc.)

echo "Projekt-Setup abgeschlossen!"
