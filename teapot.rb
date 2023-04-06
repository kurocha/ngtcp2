#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "3.0"

define_target "ngtcp2" do |target|
	target.depends :platform
	
	target.depends "Library/picotls", public: true
	
	target.depends "Build/Make"
	target.depends "Build/CMake"
	
	target.provides "Library/ngtcp2" do
		source_files = target.package.path + "ngtcp2"
		cache_prefix = environment[:build_prefix] / environment.checksum + "ngtcp2"
		package_files = [
			cache_prefix / "lib/libngtcp2.a",
			cache_prefix / "lib/libngtcp2_crypto_picotls.a",
		]
		
		cmake source: source_files, install_prefix: cache_prefix, arguments: [
			"-DENABLE_SHARED_LIB=OFF",
			"-DENABLE_OPENSSL=OFF",
			"-DENABLE_PICOTLS=ON",
			"-DPICOTLS_INCLUDE_DIR=#{environment[:header_search_paths].join(';')}",
			"-DPICOTLS_LIBRARIES=#{environment[:linkflags].join(';')}",
		], package_files: package_files
		
		append linkflags package_files
		append header_search_paths cache_prefix + "include"
	end
end

define_configuration "development" do |configuration|
	configuration[:source] = "https://github.com/kurocha/"
	
	configuration.import "ngtcp2"
	
	configuration.require "platforms"
	
	configuration.require "build-make"
	configuration.require "build-cmake"
end

define_configuration "ngtcp2" do |configuration|
	configuration.public!
	
	configuration.require "picotls"
end
