install:
	pip install cython
	pip install --upgrade .

test:
	pip install pytest
	pytest

clean:
	pip uninstall string-distance
	pip uninstall pytest
