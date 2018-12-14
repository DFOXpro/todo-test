class Todo < ApplicationRecord
	# include ActiveModel::Model
	# require 'dry-validation'
	# require 'dry/validation/schema/form'

	# ATTRIBUTES
	# attribute :id, Integer
	# attribute :data, String
	# attribute :owner_id, Integer # owner.id
	# attribute :created_at, DateTime
	# attribute :updated_at, DateTime

	belongs_to :owner

	# vanilla ACTIVE RECORD VALIDATIONS
	validates :data, presence: true, allow_blank: false
	validates :owner_id, presence: true, allow_blank: false

	# NEW DRY VALIDATIONS
	# schema = Dry::Validation.Schema do
	# 	required(:data).filled
	# 	required(:owner_id).filled
	# end

	# force owner as first set value
	def self.create_todo(new_todo_hash)
		new_todo = Todo.new
		new_todo.owner = new_todo_hash[:owner]
		new_todo.data = new_todo_hash[:data]
		new_todo.status = new_todo_hash[:status]
		new_todo.status_percentage = new_todo_hash[:status_percentage]
		new_todo
	end

	# "cypher"/overide data
	# this is just a dumb salt process dnt take serious note over this
	def data=(new_data)
		return unless new_data.present? && owner.present?
		puts "data=(#{new_data}), #{owner}"
		write_attribute :data, Base64.encode64(owner.seed + new_data)
	end
	def data
		_data = read_attribute :data
		return nil if _data.blank?
		half_decode_string = Base64.decode64 _data
		half_decode_string[(Owner::SEED_SIZE)..half_decode_string.size]
	end

	def public_info
		# self.attributes.except :owner_id
		{
			id: id,
			data: data,
			created_at: created_at,
			updated_at: updated_at,
			status: status,
			status_percentage: status_percentage,
		}
	end
end
