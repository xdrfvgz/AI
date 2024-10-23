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
