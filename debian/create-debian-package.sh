# https://askubuntu.com/questions/90764/how-do-i-create-a-deb-package-for-a-single-python-script/91616#91616


# What follows is a basic example of how a source package for a python script might look. While most of the packaging tutorials are a bit complex, they can really help if you hit a problem. That said, I first learned the basics of Debian packaging by simply looking at Debian packages. apt-get source something similar and learn by example.

# Here's your basic source package layout:

# my-script/
#     -- myScript
#     -- debian/
#         -- changelog
#         -- copyright
#         -- compat
#         -- rules
#         -- control
#         -- install
# Run dch --create in the directory to create a properly formatted debian/changelog entry.

# debian/copyright should look like:

# Format: http://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
# Upstream-Name: myScript
# Upstream-Contact: Name, <email@address>

# Files: *
# Copyright: 2011, Name, <email@address>
# License: (GPL-2+ | LGPL-2 | GPL-3 | whatever)
#  Full text of licence.
#  .
#  Unless there is a it can be found in /usr/share/common-licenses
# debian/compat can just be: 7

# debian/rules:

# #!/usr/bin/make -f

# %:
#     dh $@ --with python2
# Note that there must be "tab" before dh $@ --with python2, not spaces.

# Note: Python2 is deprecated. For a single python file, just dh $@ (without --with python) works.

# debian/control:

# Source: my-script
# Section: python
# Priority: optional
# Maintainer: Name, <email@address>
# Build-Depends: debhelper (>= 7),
#                python (>= 2.6.6-3~)
# Standards-Version: 3.9.2
# X-Python-Version: >= 2.6


# Package: my-script
# Architecture: all
# Section: python
# Depends: python-appindicator, ${misc:Depends}, ${python:Depends}
# Description: short description
#  A long description goes here.
#  .
#  It can contain multiple paragraphs
# debian/install:

# myScript usr/bin/
# This file indicates which file will be installed into which folder.

# Now build it with debuild --no-tgz-check

# This will create a functional deb package. Lintian is going to throw a few warnings regarding the lack of an orig.tar.gz, but unless you plan on creating a proper upstream project that makes tarball releases you'll probably just want to ignore that for now.