$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'psych'
require 'fileutils'
require 'digest'

module AFWAnnotation
	class GlobalConfig
		CONFIG_FILE_PATH = Dir.pwd + "/.oca.config"
		GENERATED_FILE_EXT = "gen.h"
		@@config_dic = nil;
		@@build_info = nil;

		def initialize()

			if @@config_dic.nil?
				@@config_dic = GlobalConfig.load_file(CONFIG_FILE_PATH)
			end

			@project_file_name = @@config_dic["project_file_name"]

			current_file_path = File.dirname(__FILE__);
			current_project_path = Dir.pwd + "/#{@project_file_name}"
			current_projct_path_MD5 = Digest::SHA2.new(256).update(current_project_path)
			@build_workspace_path = current_file_path + "/build/#{current_projct_path_MD5}";

			@build_info_file_path = @build_workspace_path + "/buildInfo.yaml";
			if @@build_info.nil?
				@@build_info = GlobalConfig.load_file(@build_info_file_path)

				if !@@build_info || @@build_info.nil?
					@@build_info = Hash.new
					GlobalConfig.save_to_file(@build_info_file_path, @@build_info)
				end
			end

			@build_info_cache_path = @build_workspace_path + "/annoInfos.yaml"


			default_gen_file_name = "#{self.project_file_name}AnnotationConfig"
			self.generated_file_name = @@config_dic["generated_file_name"] === nil ? default_gen_file_name : @@config_dic["generated_file_name"]

			default_config_macro_name = "k" + "#{self.project_file_name}" + "AnnotationConfigs"
			self.config_macro_name = @@config_dic["config_macro_name"] === nil ? default_config_macro_name : @@config_dic["config_macro_name"]
		end

		attr_accessor :project_file_name
		attr_accessor :generated_file_name
		attr_accessor :config_macro_name
		attr_accessor :build_workspace_path
		attr_accessor :build_info_file_path
		attr_accessor :build_info_cache_path

		def build_info_with_key(info_key)
			if @@build_info.nil?
				return nil;
			end
			return @@build_info[info_key]
		end

		def save_build_info(info_key,info_value)
			@@build_info[info_key] = info_value

			GlobalConfig.save_to_file(@build_info_file_path, @@build_info)
		end

		def generated_file_name_with_ext
			return "#{self.generated_file_name}.#{GENERATED_FILE_EXT}"
		end

		#class methods 
		def self.load_file(file_path)
			unless File.exist?(file_path)
				return;
			end
			return Psych.load_file(file_path)
		end

		def self.save_to_file(file_path, data_object)

			dir = File.dirname(file_path)
			FileUtils.mkdir_p(dir)
			File.open(file_path, 'w') do |file|
				file.write(Psych.dump(data_object))
  				file.close
  			end
		end
	end
end

