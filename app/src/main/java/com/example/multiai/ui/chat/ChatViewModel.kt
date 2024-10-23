package com.example.multiai.ui.chat

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.multiai.data.db.entities.Message
import com.example.multiai.data.repository.ChatRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class ChatViewModel @Inject constructor(
    private val repository: ChatRepository
) : ViewModel() {

    private val _messages = MutableLiveData<List<Message>>()
    val messages: LiveData<List<Message>> = _messages

    private val _availableServices = MutableLiveData<List<String>>()
    val availableServices: LiveData<List<String>> = _availableServices

    private val _uiState = MutableStateFlow<UiState>(UiState.Success)
    val uiState: StateFlow<UiState> = _uiState

    private var currentService: String? = null

    init {
        loadServices()
        observeMessages()
    }

    private fun observeMessages() {
        viewModelScope.launch {
            repository.getAllMessages()
                .catch { e -> 
                    _uiState.value = UiState.Error(e.message ?: "Fehler beim Laden der Nachrichten")
                }
                .collect { messages ->
                    _messages.value = messages
                }
        }
    }

    private fun loadServices() {
        viewModelScope.launch {
            try {
                val services = repository.getAvailableServices()
                _availableServices.value = services
                if (services.isNotEmpty() && currentService == null) {
                    currentService = services.first()
                }
            } catch (e: Exception) {
                _uiState.value = UiState.Error("Fehler beim Laden der Services: ${e.message}")
            }
        }
    }

    fun sendMessage(content: String) {
        viewModelScope.launch {
            try {
                _uiState.value = UiState.Loading

                currentService?.let { service ->
                    // Speichere Benutzernachricht
                    val userMessage = Message(
                        content = content,
                        isFromUser = true,
                        timestamp = System.currentTimeMillis(),
                        service = service
                    )
                    repository.saveMessage(userMessage)

                    // Sende an API
                    val response = repository.sendMessage(service, content)

                    // Speichere Bot-Antwort
                    val botMessage = Message(
                        content = response.response,
                        isFromUser = false,
                        timestamp = System.currentTimeMillis(),
                        service = service
                    )
                    repository.saveMessage(botMessage)

                    _uiState.value = UiState.Success
                } ?: run {
                    _uiState.value = UiState.Error("Kein Service ausgewählt")
                }
            } catch (e: Exception) {
                _uiState.value = UiState.Error("Fehler beim Senden der Nachricht: ${e.message}")
            }
        }
    }

    fun setCurrentService(service: String) {
        currentService = service
    }

    sealed class UiState {
        object Loading : UiState()
        object Success : UiState()
        data class Error(val message: String) : UiState()
    }
}
