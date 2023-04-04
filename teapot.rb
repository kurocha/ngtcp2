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
		
		picotls_path = environment[:picotls_path]
		
		picotls_libraries = [
			"-lssl", "-lcrypto",
			environment[:picotls_prefix] / "lib/libpicotls-openssl.a",
			environment[:picotls_prefix] / "lib/libpicotls-core.a",
		]
		
		cmake source: source_files, install_prefix: cache_prefix, arguments: [
			"-DENABLE_SHARED_LIB=OFF",
			"-DENABLE_OPENSSL=OFF",
			"-DENABLE_PICOTLS=ON",
			"-DPICOTLS_INCLUDE_DIR=#{environment[:picotls_prefix] / 'include'}",
			"-DPICOTLS_LIBRARIES=#{picotls_libraries.join(';')}",
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
	
	configuration.require "picotls"
end
