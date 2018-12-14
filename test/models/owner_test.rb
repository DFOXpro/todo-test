require 'test_helper'

class OwnerTest < ActiveSupport::TestCase
	test "should create an owner with random seed and user_tag" do
		owner = Owner.new
		# owner.save
		# seed size
		assert_equal 16, owner.seed.size, 'semilla valid'
		assert_not_empty owner.user_tag, 'user_tag exist'
		assert((
			owner.user_tag.size >= 3 &&
			owner.user_tag.size <= 8
		), 'user_tag valid')
	end

	test "should create an owner with random seed and designed user_tag" do
		assert Owner.new user_tag: 'gato'
		assert_equal 16, owner.seed.size, 'semilla valid'
		assert_equal 'gato', owner.user_tag, 'user_tag valid'
	end
end
