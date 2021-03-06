
# Clang-Tidy (http://clang.llvm.org/extra/clang-tidy/)
# --------------------
#
# Clang-Tidy is a clang-based C++ “linter” tool.
# Its purpose is to provide an extensible framework for diagnosing
# and fixing typical programming errors, like style violations,
# interface misuse, or bugs that can be deduced via static analysis.
# Clang-Tidy is modular and provides a convenient interface for writing new checks.
#

if (NOT ENABLE_CLANG_TIDY)
    message(WARNING "Please set ENABLE_CLANG_TIDY variable as true in order to use Clang-Tidy")
    return ()
endif ()

if (MSVC)
    message(WARNING "Please note, there is no Windows support for Clang-Tidy")
else ()
    set(CLANG_TIDY_VERSION "6.0")

    find_program(CLANG_TIDY_BIN clang-tidy-${CLANG_TIDY_VERSION})

    if (NOT CLANG_TIDY_BIN)
        message(FATAL_ERROR "Unable to locate clang-tidy-${CLANG_TIDY_VERSION}")
    endif ()

    find_program(RUN_CLANG_TIDY_BIN run-clang-tidy-${CLANG_TIDY_VERSION}.py)

    if (NOT RUN_CLANG_TIDY_BIN)
        message(FATAL_ERROR "Unable to locate run-clang-tidy-${CLANG_TIDY_VERSION}.py")
    endif ()

    list(APPEND RUN_CLANG_TIDY_BIN_ARGS
        -clang-tidy-binary ${CLANG_TIDY_BIN}
        -header-filter=${PROJECT_SOURCE_DIR}/modules
        -checks=cert*,misc*,perf*,cppc*,read*,mode*,-cert-err58-cpp,-misc-noexcept-move-constructor
    )

    add_custom_target(tidy
        COMMAND ${RUN_CLANG_TIDY_BIN} ${RUN_CLANG_TIDY_BIN_ARGS}
        COMMENT "Running clang-tidy-${CLANG_TIDY_VERSION}..."
        VERBATIM
    )
endif ()
