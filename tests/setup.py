from distutils.core import setup
from Cython.Build import cythonize

setup(
  name = 'Tests',
  ext_modules = cythonize(["*.pyx"]),
)
