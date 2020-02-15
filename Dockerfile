FROM ubuntu:18.04
LABEL Maintainer="JGV"

RUN apt-get update && apt-get install -y apt-utils
RUN apt-get install -y \
    build-essential \
    git \
    wget \
    subversion \
    cmake \
    swig3.0 \
    libgtk2.0-dev \
    libboost-all-dev \
    libglew-dev \
    libglm-dev \
    freeglut3-dev \ 
    libcairo2-dev \
    python-dev \
    libcurl4-openssl-dev \
    liboce-ocaf-dev \ 
    libssl-dev \
    bison \
    dbus \
    flex \
    curl \
    wget

WORKDIR /tmp
RUN git clone https://github.com/wxWidgets/wxWidgets.git
WORKDIR ./wxWidgets
RUN git checkout v3.0.2 && ./configure && make -j 6 && make install

WORKDIR /tmp
RUN git clone https://github.com/wxWidgets/wxPython.git
WORKDIR ./wxPython
RUN git checkout wxPy-3.0.2.0 
RUN ./configure
WORKDIR ./wxPython
RUN ./bin/subrepos-make
RUN CFLAGS=-Wno-format-security python build-wxpython.py --install --no_wxbuild --build_dir=../bld

WORKDIR /tmp
RUN git clone https://github.com/KiCad/kicad-source-mirror.git
WORKDIR ./kicad-source-mirror
RUN git checkout ${KICAD_COMMIT:-5.1.0}
WORKDIR ./scripting/build_tools
RUN chmod +x get_libngspice_so.sh
RUN ./get_libngspice_so.sh
RUN ./get_libngspice_so.sh install
RUN ldconfig

WORKDIR /tmp/kicad-source-mirror
RUN cmake DCMAKE_BUILD_TYPE=Release -DKICAD_SCRIPTING_ACTION_MENU=ON .
RUN make -j 9 && make install
RUN ldconfig

WORKDIR /tmp
RUN git clone https://github.com/KiCad/kicad-symbols.git
WORKDIR /tmp
RUN git clone https://github.com/KiCad/kicad-footprints.git
WORKDIR /tmp
RUN git clone https://github.com/KiCad/kicad-packages3d.git
WORKDIR /tmp
RUN git clone https://github.com/KiCad/kicad-templates.git

WORKDIR /tmp
RUN mkdir -p /usr/share/kicad/modules/packages3d/
RUN mv /usr/local/share/kicad/template/kicad.pro /tmp/kicad-templates
RUN ln -s /tmp/kicad-symbols /usr/share/kicad/library
RUN ln -s /tmp/kicad-footprints /usr/share/kicad/modules
RUN ln -s /tmp/kicad-packages3d /tmp/kicad-footprints/packages3d
RUN ln -s /tmp/kicad-templates /usr/share/kicad/templates






