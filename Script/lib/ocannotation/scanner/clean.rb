$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'globalConfig'
require 'fileutils'

module AFWAnnotation
	class Cleaner
		BUILD_INFO_KEY_LAST_BUILD_BRANCH = :last_build_branch

		def initialize()
			@config = AFWAnnotation::GlobalConfig.new
			@global_config = GlobalConfig.new

			@last_build_branch = @global_config.build_info_with_key(BUILD_INFO_KEY_LAST_BUILD_BRANCH)
		end

		def self.clean(is_force_clean=false)
			cleanner = AFWAnnotation::Cleaner.new
			if is_force_clean || cleanner.should_clean?
				cleanner.do_clean
			end
		end

		def do_clean
			FileUtils.rm_rf("#{@global_config.build_info_file_path}")

			gen_file_path = Dir.pwd + "/#{@global_config.generated_file_name_with_ext}"
			FileUtils.rm_f(gen_file_path)
			p "Removed generated .gen.h file"

			p "cleanning done"
		end

		def should_clean?
			current_branch = %x( git rev-parse --abbrev-ref HEAD 2>/dev/null ).strip

			if @last_build_branch.nil?
				p "git branch info does not exits, do cleanup first just in case"
				@global_config.save_build_info(BUILD_INFO_KEY_LAST_BUILD_BRANCH,current_branch)
				return true
			end

			if current_branch.nil?
				p "error when getting current git branch, please look into it"
				return true
			end

			if current_branch != @last_build_branch
				p "git branch changed, do cleanup first"
				@global_config.save_build_info(BUILD_INFO_KEY_LAST_BUILD_BRANCH,current_branch)
				return true
			end

			return false
		end


	end
end