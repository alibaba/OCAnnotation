$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'xcodeproj'
require 'annotation'
require 'configGenerator'
require 'fileProcessor'
require 'benchmark'
require 'globalConfig'

module AFWAnnotation

	class AnnotationScanner
	  require 'xcodeproj'		

	    ALL_FILES_STORAGE_KEY_PATH = "path"
		ALL_FILES_STORAGE_KEY_MTIME = "mtime"

		def initialize(project_file_path)
			@project_file_path = project_file_path
	
		  @total_benchmark = Benchmark.new	
			@global_config = GlobalConfig.new

			self.init_all_files

			files_to_scan, files_skipped = self.preprocess_files

			annotations = self.scan_files(files_to_scan)
			
			self.print_skipped_files(files_skipped,false)

			self.generate_config_file(annotations)

		end

		def init_all_files
			@all_files = nil
			if self.should_open_project
				@all_files = Array.new
				self.open_project 
				self.prepare_file_infos
			else
				@all_files = @global_config.build_info_with_key(:all_files)
				if @all_files.nil?
					@all_files = Array.new
				end
				print "all_files Loaded from cache: #{@all_files.count} files \n"

			end
		end
		
		# 打开xcodeproject文件
		# 耗时操作，需要尽量少执行
		def open_project
			bm = Benchmark.new
			@proj = Xcodeproj::Project.open(@project_file_path)
			bm.p {|time| "xcode project file opened: #{time}"}
		end

		# 判断是否需要重新打开工程文件
		# 判断标准：工程文件的mtime距离上次是否发生变化 
		def should_open_project
			
			project_file_path = @project_file_path + "/project.pbxproj"
			proj_mtime = File.mtime(project_file_path).to_i

			last_proj_mtime = @global_config.build_info_with_key(:last_proj_mtime)
			if last_proj_mtime.nil?
				last_proj_mtime = 0	
			end

			@global_config.save_build_info(:last_proj_mtime,proj_mtime)
			if last_proj_mtime == proj_mtime
				return false
			else
				return true
			end
		end

		def prepare_file_infos()
			bm = Benchmark.new
			@proj.groups.each do |group|
				self.add_files_from_group(group)
			end
			bm.p {|time| "files infos readed from xcode project file :" + time}
		end

		# 对all_files进行预处理，找出需要扫描的文件，同时更新需要扫描的文件的扫描时间
		# 判断条件：未扫描过，或自从上次扫描后发生变化的
		def preprocess_files()
			bm = Benchmark.new
			files_to_scan = Array.new
			files_skipped = Array.new

			@all_files.each do |fileInfoDic|
				path = fileInfoDic[ALL_FILES_STORAGE_KEY_PATH]
				lastScanTimestamp = fileInfoDic[ALL_FILES_STORAGE_KEY_MTIME]	
				modifyTime = File.mtime(path).to_i
				if (not lastScanTimestamp.nil?) && lastScanTimestamp == modifyTime 
					files_skipped.push(path)
				else
					fileInfoDic[ALL_FILES_STORAGE_KEY_MTIME] = modifyTime
					files_to_scan.push(path)
				end
			end

			@global_config.save_build_info(:all_files,@all_files)
			bm.p {|time| "preprocess files : #{time}"}
			return files_to_scan, files_skipped
		end

		# 打印不需要扫描的文件信息
		def print_skipped_files(skipped_files,shouldPrintDetail)
			if skipped_files.empty? 
				return
			end

			print "#{skipped_files.count} files are skipped (not changed since last scan)\n"
			
			unless shouldPrintDetail 
				return
			end

			print "skipped files as follows:\n"

			skipped_files.each do |path| 
				print "#{path},"
			end

			print "\n"

		end

		def add_files_from_group(group)
			group.files.each do |file|
				self.add_file(file,group)
			end

			group.groups.each do |subGroup|
				self.add_files_from_group(subGroup)
			end
		end

		def add_file(file,containerGroup)
			if file.nil? || containerGroup.nil?
				return
			end
			if file.path.nil?
				return
			end

			if file.path.end_with?('.h') || file.path.end_with?('.m')
			 	path = Dir.pwd + file.hierarchy_path
				unless File.exist?(path)
					puts "invalid path:#{path}"
					return
				end
				fileInfoDic = Hash.new
				fileInfoDic[ALL_FILES_STORAGE_KEY_PATH] = path
				fileInfoDic[ALL_FILES_STORAGE_KEY_MTIME] = 0
				@all_files.push(fileInfoDic)
			end
		end

		def scan_files(files)
			bm = Benchmark.new
			all_annotations = Array.new
			files.each do |path|
				file_processor = AFWAnnotation::FileProcessor.new(path)
				annotations = file_processor.find_annotations
				if ! annotations.empty?
					annotations.each do |a|
						all_annotations.push(a)
					end
				end
			end
			bm.p {|time| "#{files.count} files scanned : #{time}"}

			return all_annotations
		end

		def generate_config_file(annotations)
			bm = Benchmark.new

			config_generator = ConfigGenerator.new()

			annotations.each do |a|
				config_generator.add_annotation(a)
			end

			config_generator.generate_oc_header()
			config_generator.deploy

			bm.p {|time| "OC header generated: #{time}"}
			
			@total_benchmark.p {|time| "total build time: #{time}"}
		end
	end
end
