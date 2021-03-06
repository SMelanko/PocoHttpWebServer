
# Cppcheck
# --------------------
#
# Install and prepare a tool for static C/C++ code analysis.
#

if (NOT ENABLE_CPPCHECK)
	return ()
endif ()

include(ExternalProject)

list(APPEND CPPCHECK_CMAKE_ARGS
	"-DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}"
)

ExternalProject_Add(
	cppcheck
	# URL of git repo.
	GIT_REPOSITORY https://github.com/danmar/cppcheck.git
	# Git branch name, commit id or tag.
	GIT_TAG 1.82
	# Tell Git to clone with --depth 1.
	GIT_SHALLOW 1
	# Arguments to CMake command line.
	CMAKE_ARGS ${CPPCHECK_CMAKE_ARGS}
	# Root dir for entire project.
	PREFIX ${CMAKE_BINARY_DIR}/external/cppcheck/prefix
	# Directory to store temporary files.
	TMP_DIR ${CMAKE_BINARY_DIR}/external/cppcheck/tmp
	# Directory to store step timestamps.
	STAMP_DIR ${CMAKE_BINARY_DIR}/external/cppcheck/stamp
	# Directory to store downloaded files.
	DOWNLOAD_DIR ${CMAKE_BINARY_DIR}/external/cppcheck/download
	# Source dir to be used for build.
	SOURCE_DIR ${CMAKE_BINARY_DIR}/external/cppcheck/src
	# Specify build dir location.
	BINARY_DIR ${CMAKE_BINARY_DIR}/external/cppcheck/build
)

list(APPEND CPPCHECK_ARGS
	# Forces cppcheck to check all files as the given language.
	--language=c++
	# Set default standard.
	--std=c++11
	# Enable all checks.
	--enable=all
	# More detailed error reports.
	--verbose
	# Suppress a specific warning.
	--suppress=missingIncludeSystem
	${CMAKE_SOURCE_DIR}/modules
)

add_custom_target(
	check
	COMMAND ${CMAKE_BINARY_DIR}/bin/cppcheck ${CPPCHECK_ARGS}
	COMMENT "Running cppcheck..."
)

