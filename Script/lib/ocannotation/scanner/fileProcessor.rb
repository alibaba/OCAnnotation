$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'annotation'

module AFWAnnotation
	class FileProcessor
		include Constants

		SHOULD_LOG_DETAIL = false

		def initialize(file_path)
			@file_path = file_path
			@current_class = nil
		end
	
		def find_annotations
			annotations = Array.new
			begin
				@lines = File.readlines(@file_path,:encoding => 'utf-8')
				self.log("processing : #{@file_path}")
				0.upto(@lines.count) do |index|
					line = @lines[index]
					if self.is_interface_start_line?(line)
						@current_class = line.scan(/@interface\s+(\w*)\s*/)[0][0]
					end 

					if self.is_implementation_start_line?(line)
						@current_class = line.scan(/^@implementation\s+(\w*)\s*/)[0][0]
					end 

					if self.is_annotation_line?(line)
						self.log("annotation line detected :#{line}") 
						anno = Annotation.new(line,@file_path)
						self.update_anno_with_line_index(anno,index)
						annotations.push(anno)			
						self.log("\n")
					end
				end
			rescue => ex
				print ex.message,"\n"
			ensure
			end
			
			return annotations
		end

		def next_useful_line(current_index)
		  next_useful_lineindex = current_index + 1
			current_index.upto(@lines.count) do |index|
				line = @lines[index]
				if self.is_property_line?(line) || self.is_interface_start_line?(line) || self.is_implementation_start_line?(line) || self.is_method_start_line?(line)
				  	next_useful_lineindex = index
					break
				end
			end	
			return next_useful_lineindex
		end

		def update_anno_with_line_index(anno,line_index)
			line = @lines[line_index]
			nextLineIndex = self.next_useful_line(line_index)
			nextLine = @lines[nextLineIndex]
			#puts "next_useful_line",nextLine
			if self.is_property_line?(nextLine)
				anno.position = Constants::ANNO_POSITION[:PROPERTY]
				anno.raw_relative_string = nextLine
				anno.class_name = @current_class
				self.log("property anno found and added #{anno.raw_relative_string}")		
			end

			if self.is_interface_start_line?(nextLine)
				anno.position =  Constants::ANNO_POSITION[:CLASS]
				anno.raw_relative_string = nextLine
				@current_class = nextLine.scan(/@interface\s+(\w*)\s*/)[0][0]
				anno.class_name = @current_class
				self.log("class anno found and added #{@current_class}")									
			end

			if self.is_implementation_start_line?(nextLine)
				anno.position = Constants::ANNO_POSITION[:CLASS]
				anno.raw_relative_string = nextLine
				@current_class = nextLine.scan(/^@implementation\s+(\w*)\s*/)[0][0]
				anno.class_name = @current_class
				self.log("class anno found and added #{@current_class}")
			end
			
			if self.is_method_start_line?(nextLine)
				anno.position = Constants::ANNO_POSITION[:METHOD]
				anno.raw_relative_string = self.method_rawinfo_with_startLineIndex(nextLineIndex)
				anno.class_name = @current_class
				self.log("method anno found and added #{anno.raw_relative_string}")								
			end
			
			params = anno.params

		end

		def is_annotation_line?(line)
			/^#pragma annotation/ =~ line
		end

		def is_header_file?
			@file_path.end_with?('.h')
		end
		
		def is_property_line?(line)
		  /^@property/ =~ line
		end
		
		def is_method_start_line?(line)
		  /^-( )?\(/ =~ line
		end
		
		def method_rawinfo_with_startLineIndex(start_line_index)
			method_def_lines = Array.new
			start_line_index.upto(@lines.count) do |lineIndex|
				line = @lines[lineIndex]
				
				if /{/ =~ line then
					if /^{/ =~ line
						#puts "found ^{"
						break
					else
						#puts "fount { at the end of last line"
						indexOfEnd = line.index("{")
						line = line.slice(0,indexOfEnd-1)
					    method_def_lines.push(line)
						break
					end
				elsif /;$/ =~ line then
					# is end of method signature
					line = line.slice(0,line.index(";"))
					method_def_lines.push(line)
					break
				else
					method_def_lines.push(line)
				end
			end
			return method_def_lines.join("|")
		end

		def is_interface_start_line?(line)
			/^@interface / =~ line
		end

		def is_implementation_start_line?(line)
			/^@implementation / =~ line
		end

		def is_end_line?(line)
			/^@end/ =~ line
		end

		def log(msg)
			unless SHOULD_LOG_DETAIL
				return
			end
			puts msg
		end
	end
end
