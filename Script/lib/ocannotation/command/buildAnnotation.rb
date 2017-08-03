$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'globalConfig'
require 'annotationScanner'
require 'clean'

ARG_CMD_CLEAN = "-c"
ARG_CMD_BUILD = "-b"

arguments = ARGV
if arguments.nil? || arguments.empty?
	arguments = [ARG_CMD_CLEAN,ARG_CMD_BUILD]
end


should_clean = arguments.include?(ARG_CMD_CLEAN)
should_build = arguments.include?(ARG_CMD_BUILD)

if should_clean
	AFWAnnotation::Cleaner.clean(true)
end

if should_build
	
	config = AFWAnnotation::GlobalConfig.new
	project_file_name = config.project_file_name

	AFWAnnotation::Cleaner.clean
	scanner = AFWAnnotation::AnnotationScanner.new(Dir.pwd + "/#{project_file_name}.xcodeproj")
end


