# frozen_string_literal: true
require_relative 'test_helper'
require 'xbee'

class TestPacket < Minitest::Test
	UUT = XBee::Packet


	def test_initialization
		uut = UUT.new [0x7e, 0x12, 0x34, 0x56]

		assert_equal [0x7e, 0x12, 0x34, 0x56], uut.data
		assert_equal 0x04, uut.length
		assert_equal 0xe5, uut.checksum
		assert_equal [0x7e, 0x00, 0x04, 0x7e, 0x12, 0x34, 0x56, 0xe5], uut.bytes
		assert_equal [0x7e, 0x00, 0x04, 0x7d, 0x5e, 0x12, 0x34, 0x56, 0xe5], uut.bytes_escaped
	end


	def test_special_byte
		assert UUT.special_byte?(0x11)
		assert UUT.special_byte?(0x13)
		assert UUT.special_byte?(0x7d)
		assert UUT.special_byte?(0x7e)
		refute UUT.special_byte?(0x00)
	end


	def test_unescape
		input = [0x00, 0x7d, 0x31, 0x22]
		expected = [0x00, 0x11, 0x22]
		actual = UUT.unescape input
		assert_equal expected, actual

		input = [0x00, 0x7d, 0x11 ^ 0x20, 0x7d, 0x13 ^ 0x20, 0x44, 0x7d, 0x7d ^ 0x20, 0x7d, 0x7e ^ 0x20, 0x00]
		expected = [0x00, 0x11, 0x13, 0x44, 0x7d, 0x7e, 0x00]
		actual = UUT.unescape input
		assert_equal expected, actual
	end
end