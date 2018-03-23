from setuptools import setup, find_packages, Extension

ext_modules = [
    Extension(
        "string_distance.edit_distance",
        ["string_distance/edit_distance.pyx"],
    ),
    Extension(
        "string_distance.float_edit_distance",
        ["string_distance/float_edit_distance.pyx"]
    ),
]

version = "0.1.2"

setup(
    name="string_distance",
    version=version,
    description="Minimum Edit Distance",
    long_description=open('README.md').read(),
    author="Brian Lester",
    author_email="blester125@gmail.com",
    url="https://github.com/blester125/string_distance",
    download_url=f"https://github.com/blester125/string_distance/archive/{version}.tar.gz",
    license="MIT",
    packages=find_packages(),
    package_data={
        'string_distance': [
            'string_distance/edit_distance.c',
            'string_distance/float_edit_distance.c',
            'string_distance/edit_distance.pxd',
            'string_distance/float_edit_distance.pxd',
        ],
    },
    include_package_data=True,
    keywords=["NLP", "fuzzy", "matching"],
    setup_requires=[
        'cython',
    ],
    ext_modules=ext_modules
)
