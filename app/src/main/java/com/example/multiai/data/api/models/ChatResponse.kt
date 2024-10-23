package com.example.multiai.data.api.models

data class ChatResponse(
    val response: String,
    val service: String
)

data class ServicesResponse(
    val services: List<String>
)
