import setuptools

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setuptools.setup(
    name="summerchild_quiz",
    version="0.0.1",
    author="Laura Summers",
    author_email="summerscope@gmail.com",
    description="Sweet summer child score, a risk assessment quiz for automation and ML.",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/summerscope/summerchildpy",
    project_urls={
        "Bug Tracker": "https://github.com/summerscope/summerchildpy/issues",
    },
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: GNU Affero General Public License v3 or later (AGPLv3+)",
        "Operating System :: OS Independent",
    ],
    package_dir={"": "."},
    packages=['summerchild'],
    package_data={
        "summerchild": ["questions.json"],
    },
    python_requires=">=3.7",
    entry_points={
        'console_scripts': ['summerchild_quiz = summerchild:main']
    },
)
