class Owner < ApplicationRecord
	USER_TAG_MIN_SIZE = 3
	USER_TAG_SIZE = 8
	SEED_SIZE = 16
	validates :user_tag, uniqueness: true
	validates :seed, uniqueness: true
	after_initialize :generate_onwer_keys

	private
	def generate_onwer_keys
		self.seed = generate_seed if seed.blank?
		self.user_tag = generate_user_tag if user_tag.blank?
	end
	def generate_user_tag
		Array.new((USER_TAG_MIN_SIZE..USER_TAG_SIZE).to_a.sample){[*"A".."Z", *"0".."9"].sample}.join
	end
	def generate_seed
		Array.new(SEED_SIZE){[*"A".."Z", *"0".."9"].sample}.join
	end
end
