package com.example.multiai.ui.chat.adapters

import android.view.LayoutInflater
import android.view.ViewGroup
import android.view.Gravity
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.example.multiai.data.db.entities.Message
import com.example.multiai.databinding.ItemMessageBinding
import io.noties.markwon.Markwon

class ChatAdapter : ListAdapter<Message, ChatAdapter.MessageViewHolder>(MessageDiffCallback()) {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MessageViewHolder {
        val binding = ItemMessageBinding.inflate(
            LayoutInflater.from(parent.context), parent, false
        )
        return MessageViewHolder(binding)
    }

    override fun onBindViewHolder(holder: MessageViewHolder, position: Int) {
        holder.bind(getItem(position))
    }

    inner class MessageViewHolder(
        private val binding: ItemMessageBinding
    ) : RecyclerView.ViewHolder(binding.root) {
        
        private val markwon = Markwon.create(binding.root.context)

        fun bind(message: Message) {
            binding.apply {
                if (message.isFromUser) {
                    messageCard.layoutParams = (messageCard.layoutParams as ViewGroup.MarginLayoutParams).apply {
                        gravity = Gravity.END
                        marginStart = 48 * binding.root.context.resources.displayMetrics.density.toInt()
                        marginEnd = 8 * binding.root.context.resources.displayMetrics.density.toInt()
                    }
                } else {
                    messageCard.layoutParams = (messageCard.layoutParams as ViewGroup.MarginLayoutParams).apply {
                        gravity = Gravity.START
                        marginStart = 8 * binding.root.context.resources.displayMetrics.density.toInt()
                        marginEnd = 48 * binding.root.context.resources.displayMetrics.density.toInt()
                    }
                    // Parse Markdown für Bot-Antworten
                    markwon.setMarkdown(messageText, message.content)
                }

                // Normale Textnachricht für Benutzer
                if (message.isFromUser) {
                    messageText.text = message.content
                }
            }
        }
    }

    class MessageDiffCallback : DiffUtil.ItemCallback<Message>() {
        override fun areItemsTheSame(oldItem: Message, newItem: Message): Boolean {
            return oldItem.id == newItem.id
        }

        override fun areContentsTheSame(oldItem: Message, newItem: Message): Boolean {
            return oldItem == newItem
        }
    }
}
