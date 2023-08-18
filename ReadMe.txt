Scripts
=======

Introduction
------------

These are the build scripts I use compile the code with both Visual C++ and
GCC, via Code::Blocks. It also contains various other scripts to run the tests,
configure STLport, upgrade projects to newer VC++ versions, build deployment
packages, etc.

Releases
--------

Stable releases are formally packaged and made available from my Win32 tools page:
http://www.chrisoldwood.com/win32.htm

The latest code is available from my GitHub repo:
https://github.com/chrisoldwood/Scripts

Dependencies
------------

Aside from the obvious major dependencies like Visual C++ and Code::Blocks, the 
other scripts might require additional 3rd party tools, e.g. building the
deployment packages. These include:

* Chocolatey: https://chocolatey.org/install
* 7-Zip: choco install -y 7zip
* WiX: choco install -y wixtoolset (and manually update the PATH)
* GNU Tools: choco install -y git (or gow -- GNU on Windows)

Contact Details
---------------

Email: gort@cix.co.uk
Web:   http://www.chrisoldwood.com

Chris Oldwood
18th August 2023
