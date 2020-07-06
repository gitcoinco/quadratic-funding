import setuptools

with open('README.md', 'r') as fh:
    long_description = fh.read()

setuptools.setup(
    name='quadratic_funding',
    version='0.0.1',
    author='Frank Chen, Aditya Anand Michael Chelliah, Kevin Owocki',
    author_email='team@gitcoin.co',
    description='This is the open source quadratic funding implementation found on gitcoin.co/grants.',
    long_description='This is an open source implementation of quadratic funding, a design for philanthropic and publicly-funded seeding, which allows for optimal provisioning of funds to an ecosystem of public goods. You can find the live product implementation at gitcoin.co/grants',
    long_description_content_type='text/markdown',
    url='https://github.com/gitcoinco/quadratic-funding',
    packages=setuptools.find_packages(),
    classifiers=[
        'Programming Language :: Python :: 3',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
    ],
    python_requires='>=3.6',
    test_suite='nose.collector',
    tests_require=['nose']
)
