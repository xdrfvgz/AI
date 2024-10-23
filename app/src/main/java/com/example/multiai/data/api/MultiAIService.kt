package com.example.multiai.data.api

import com.example.multiai.data.api.models.ChatRequest
import com.example.multiai.data.api.models.ChatResponse
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.POST
import retrofit2.http.Path

interface MultiAIService {
    @POST("chat")
    suspend fun sendMessage(@Body request: ChatRequest): ChatResponse

    @GET("services")
    suspend fun getServices(): ServicesResponse

    @GET("service/{service}/config")
    suspend fun getServiceConfig(@Path("service") service: String): Map<String, Any>
}
