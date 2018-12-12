class Todo < ApplicationRecord
	belongs_to :owner
	validates :data, presence: true, allow_blank: false
	validates :owner_id, presence: true, allow_blank: false

	# "cypher"/overide data
	# this is just a dumb salt process dnt take serious note over this
	def data=(new_data)
		write_attribute :data, Base64.encode64(owner.seed + new_data)
	end
	def data
		_data = read_attribute :data
		return nil if _data.blank?
		half_decode_string = Base64.decode64 _data
		half_decode_string[(Owner::SEED_SIZE)..half_decode_string.size]
	end
end
