#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "3.0"

define_target "ngtcp2" do |target|
	target.depends :platform
	
	target.depends "Library/z", public: true
	
	target.depends "Build/Make"
	target.depends "Build/CMake"
	
	target.provides "Library/ngtcp2" do
		source_files = target.package.path + "ngtcp2"
		cache_prefix = environment[:build_prefix] / environment.checksum + "ngtcp2"
		package_files = cache_prefix / "lib/libngtcp2.a"
		
		cmake source: source_files, install_prefix: cache_prefix, arguments: [
			"-DBUILD_SHARED_LIBS=OFF",
		], package_files: package_files
		
		append linkflags package_files
		append header_search_paths cache_prefix + "include"
	end
end

define_configuration "ngtcp2" do |configuration|
	configuration[:source] = "https://github.com/kurocha/"
	
	configuration.require "platforms"
	
	configuration.require "build-make"
	configuration.require "build-cmake"
end
