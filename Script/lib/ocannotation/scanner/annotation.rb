module AFWAnnotation
	module Constants
		ANNO_POSITION = {
			:CLASS => 'class',
			:METHOD => 'method',
			:PROPERTY => 'property'
		}.freeze
	end
	class Annotation
		include Constants
		def initialize(raw_string,file_path)
			self.raw_string = raw_string
			self.file_path = file_path
		end
		
		attr_accessor :file_path
		attr_accessor :position
		attr_accessor :type
	    attr_accessor :class_name
	    attr_accessor :method_name
		attr_accessor :property_name	
		attr_accessor :raw_string
		attr_accessor :raw_relative_string
		
		public

		def raw_string=(raw_string)
			@raw_string = raw_string
			params = self.params
			self.type = params['type']
			if self.type.nil?
				self.type = 'default'
			end
		end	
		
		def property_name
			if self.position == ANNO_POSITION[:PROPERTY]
				unless self.raw_relative_string.nil?
					reg = Regexp.new('[\s]*[\*]?([\w]*)[\s]*;')
					reg =~ self.raw_relative_string
					return $1
				end
			end
			return nil
		end


		def method_selector
			if self.position == ANNO_POSITION[:METHOD]
				unless self.raw_relative_string.nil?
					if self.raw_relative_string.include? ':'
						selector_part_reg = Regexp.new('[[\s]*|\)](\w*:)')
						selector_parts = self.raw_relative_string.scan(selector_part_reg)
						return selector_parts.join()
					else
						selector_part_reg = Regexp.new('[[\s]*|\)](\w*)$')
						selector_parts = self.raw_relative_string.scan(selector_part_reg)
						return selector_parts.join()
					end

				end
			end
			return nil
		end

		def params
			if @raw_string.nil?
				return nil	
			end
			
			reg = Regexp.new('\(([\w|\s|=|\'|\"|,|:\.]*)\)')

			reg =~ @raw_string
			params_string = $1.strip

			param_pair_reg = Regexp.new('[\s]*([\w]*[\s]*[:|=][\s]*\"[^\"]*\")[\s]*[,]?')
			param_pairs = params_string.scan(param_pair_reg)
			
			params = Hash.new()
			param_pairs.each do |param_pair|
				kv_string = param_pair[0]
				kv_reg = Regexp.new('([\w]*)[\s]*[:|=][\s]*\"([^\"]*)\"')
				kv_reg =~ kv_string
				params[$1]=$2
			end
			return params			
		end


	end
end

