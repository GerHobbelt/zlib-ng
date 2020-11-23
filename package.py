name = "zlib"

version = "1.2.11.1"

authors = ["madler"]

requires = [
    "cmake",
    "gcc",
]

build_system = "cmake"

def commands():
    env.ZLIB_ROOT = "{root}"
    env.ZLIB_INCLUDE_DIRS = "{root}/include"
