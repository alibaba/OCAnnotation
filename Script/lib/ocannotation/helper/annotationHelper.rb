$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'xcodeproj'
require 'psych'

class SetupHelper

	PROJ_FILE_NAME_KEY = "project_file_name"
	UPDATE_GITIGNORE_KEY = "update_gitignore"
	GITIGNORE_PATH_KEY = "gitignore_file_path"
	GEN_FILE_NAME_KEY = "generated_file_name"
	MACRO_NAME_KEY = "config_macro_name"

	def initialize

	end

	attr_accessor :project_file_name
	attr_accessor :gen_file_name

	# Start annotation initialization for your project.
	def start_setup
		read_config()

		puts "Initializing annotation for project: #{self.project_file_name} ..."
		puts "================================="

		if add_annotation_target()
			puts "================================="
			puts "Annotation initialization for project #{self.project_file_name} done.(●'◡'●)ﾉ♥"
		end
	end

	# Read customized config info from .oca.config file
	# 读取.oca.config的配置信息
	def read_config
		config_file_path = Dir.pwd + "/.oca.config"

		unless File.exist?(config_file_path)
			puts ".config file does NOT exist. Read configuration fails."
			return false
		end

		puts "Reading configuration:"
		config_dic = Psych.load_file(config_file_path)

		if config_dic.empty?
			puts ".config file is empty. Read configuration fails."
			return false
		end

		unless config_dic.has_key?(PROJ_FILE_NAME_KEY)
			puts "Read project name fails. Please configure your project name at project_file_name in .oca.config"
			return false
		end

		config_dic.each do |key, value|
			puts "Custom config -- #{key} : #{value}"
		end

		self.project_file_name = config_dic[PROJ_FILE_NAME_KEY]

		unless config_dic[GEN_FILE_NAME_KEY]
			self.gen_file_name = "#{self.project_file_name}AnnotationConfig"
			puts "Set default config -- config_macro_name : #{self.gen_file_name}"
		end

		return true
	end

	# Creates annotation target and add it to the project. 
	# 项目中增加Annotation target
	def add_annotation_target
		project_path = Dir.pwd + "/#{self.project_file_name}.xcodeproj" 

		project = Xcodeproj::Project.open(project_path)
		main_target = project.targets.first

		clean_annotation_target(project)
		annotation_target = create_annotation_target(project, main_target)
		add_script_phase(annotation_target)

		project.save()

		return true
	end

	# Removes annotation targets already embedded.
	# 清除项目中已有的Annotation Target
	def clean_annotation_target(project)
		project.targets.each do |target|
			if target.name == "Annotation" 
				target.remove_from_project()
				puts "Cleaned previous annotation settings."
			end
		end
	end

	# Creates a new annotation target and adds it to your project's dependency list.
	# 添加Annotation Target，并在原主target的dependency列表中加入Annotation Target
	def create_annotation_target(project, main_target)
		annotation_target = project.new_aggregate_target("Annotation", [])
		if annotation_target.nil?
			puts "Creation of new annotation target fails."
		end

		main_target.add_dependency(annotation_target)
		puts "Add annotation target to #{project_file_name} project's dependency list."
		return annotation_target
	end

	# Adds a new script phase to annotation target to run 'build.sh' automatically.
	# Annotation target - Build Phases - 添加New Run Script Phase. 自动运行build.sh脚本.
	def add_script_phase(annotation_target)
		annotation_script = annotation_target.new_shell_script_build_phase("Annotation Script")
		annotation_script.shell_script = "bash -ilc \"oca_build\""
		puts "Add script phase to annotation target's build phases."
  end

end
