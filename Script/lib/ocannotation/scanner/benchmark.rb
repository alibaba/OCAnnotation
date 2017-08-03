module AFWAnnotation
	class Benchmark
		def initialize()
			self.mark_begin
		end
		
		public

		def p
			self.mark_end
			milisecs = (@end_time_int - @begin_time_int)*1000
			secs = milisecs/1000.0
			if secs < 0.00001
				secs = 0
			end

			time_string =  "#{secs.to_s} seconds (#{@begin_time_int.strftime("%T.%6N")} - #{@end_time_int.strftime("%T.%6N")})"
			msg = yield time_string
			puts msg
		end

		def mark_begin
			@begin_time_int = Time.now
		end

		def mark_end
			@end_time_int = Time.now
		end
	end
end
