ARG UBUNTU_VERSION

FROM ubuntu:$UBUNTU_VERSION

ARG PYTHON_VERSION
ARG REALSENSE_VERSION
ENV PYTHON_VERSION=$PYTHON_VERSION
ENV REALSENSE_VERSION=$REALSENSE_VERSION

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
  apt-get -y install python${PYTHON_VERSION} python${PYTHON_VERSION}-dev python3-distutils python3-pip libssl-dev libxinerama-dev libsdl2-dev curl libblas-dev liblapack-dev gfortran libssl-dev git cmake libusb-1.0-0-dev && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get clean
  
RUN cd / && \
  git clone --depth 1 --branch v$REALSENSE_VERSION https://github.com/IntelRealSense/librealsense.git && \
  cd librealsense && \
  mkdir build && \
  cd build && \
  cmake ../ -DBUILD_PYTHON_BINDINGS:bool=true -DPYTHON_EXECUTABLE=/usr/bin/python${PYTHON_VERSION} -DCMAKE_BUILD_TYPE=Release -DOpenGL_GL_PREFERENCE=GLVND && \
  make -j4 && \
  make install && \
  cd / && rm -rf librealsense
  
ENV PYTHONPATH /usr/lib/python3/dist-packages/pyrealsense2

