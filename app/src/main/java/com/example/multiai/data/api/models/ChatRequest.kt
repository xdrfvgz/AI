package com.example.multiai.data.api.models

data class ChatRequest(
    val service: String,
    val message: String,
    val config: Map<String, Any>? = null,
    val systemPrompt: String? = null
)
