# Use an official and the latest GCC image.
FROM gcc

# Install the latest CMake.
ADD https://cmake.org/files/v3.10/cmake-3.10.0-Linux-x86_64.sh /cmake-3.10.0-Linux-x86_64.sh
RUN mkdir /opt/cmake
RUN sh /cmake-3.10.0-Linux-x86_64.sh --prefix=/opt/cmake --skip-license
RUN ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
RUN rm /cmake-3.10.0-Linux-x86_64.sh
RUN cmake --version

# Update system to the newest versions of packages and their dependencies.
RUN apt-get update
# Install additional packages.
RUN apt-get install -y \
    mc \
    python-dev

# Install Python package manager.
ADD https://bootstrap.pypa.io/get-pip.py /get-pip.py
RUN python get-pip.py
RUN rm /get-pip.py
RUN pip install -q -U pip

# Install the latest Conan.
RUN pip install -q --no-cache-dir conan
RUN conan user
RUN conan --version

# Make port 80 available to the world outside this container.
EXPOSE 80

# Set the working directory.
WORKDIR /projects
# Copy the github repo into the container at $WORKDIR directory.
RUN git clone https://github.com/SMelanko/PocoHttpWebServer.git
# Build the project.
WORKDIR PocoHttpWebServer/scripts
RUN chmod +x build-gcc-x64-release
RUN ./build-gcc-x64-release

# Run HTTP WEB server.
WORKDIR ../build/gcc-x64-Release/bin

#CMD ["./server"]
