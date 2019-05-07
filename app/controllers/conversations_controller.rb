# frozen_string_literal: true

class ConversationsController < ApplicationController
	def create
		@conversation = Conversation.get(current_user.id, params[:user_id])

		add_to_conversations unless conversated?

		respond_to do |format|
			format.js
		end
		respond_to do |format|
			format.js {render inline: "location.reload();" }
		end
	end

	$users = []
	# POST /ajax/sum
	def ajax_sum
		@user = current_user
		puts @user.id
		if !$users.include? @user.id
			$users.push(@user.id)
		end
		puts "USERS:" + $users.to_s
		# Do something with input parameter and respond as JSON with the output
		if $users.length > 1 
			puts "match found"
			# here is the connection
			# $users.pop(current_user.id)
			puts "USERS AFTER POP" + $users.to_s
			@conversation = Conversation.get(current_user.id, $users.first)
			add_to_conversations unless conversated?
			respond_to do |format|
				format.js
			end
			respond_to do |format|
				format.js {render inline: "location.reload();" }
			end
			$users.clear
			puts "CLEARED"
		end
	end

	def close
		@conversation = Conversation.find(params[:id])

		session[:conversations].delete(@conversation.id)

		respond_to do |format|
			format.js
		end
	end

    private

		def add_to_conversations
			session[:conversations] ||= []
			session[:conversations] << @conversation.id
		end

		def conversated?
			session[:conversations].include?(@conversation.id)
		end
end
