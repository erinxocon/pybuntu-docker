FROM ubuntu:19.04

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV PATH /usr/local/bin:$PATH
ENV PYTHON_VERSION 2.7.16
ENV PYTHON_PIP_VERSION 19.0.3
ENV BUILD_DEPS build-essential \
    libncursesw5-dev \
    libreadline-gplv2-dev \
    libssl-dev \
    libgdbm-dev \
    libc6-dev \
    libsqlite3-dev \
    libbz2-dev \
    ca-certificates \
    zlib1g-dev \
    wget \
    libffi-dev
ENV REMOVE_DEPS build-essential \
    wget

RUN apt update && apt install --no-install-recommends --no-install-suggests -y ${BUILD_DEPS} \
    && wget -O- https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz | tar xz \
    && cd Python-${PYTHON_VERSION}/ \
    && ./configure \
    --without-ensurepip \
    --enable-loadable-sqlite-extensions \
    && make -j "$(nproc)" \
    && make install \
    && find /usr/local -depth \
    \( \
    \( -type d -a \( -name test -o -name tests \) \) \
    -o \
    \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
    \) -exec rm -rf '{}' + \
    && rm -rf /Python-${PYTHON_VERSION} \
    \
    && python --version \
    \
    && cd \
    \
    set -ex; \
    \
    wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py'; \
    \
    python get-pip.py \
    --disable-pip-version-check \
    --cache-dir=/pipcache \
    "pip==$PYTHON_PIP_VERSION" \
    ; \
    pip --version; \
    \
    find /usr/local -depth \
    \( \
    \( -type d -a \( -name test -o -name tests \) \) \
    -o \
    \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
    \) -exec rm -rf '{}' +; \
    rm -f get-pip.py \
    && rm -rf /pipcache \
    && apt remove --autoremove --purge -y ${REMOVE_DEPS} \
    && rm -rf /var/lib/apt/lists/*

CMD ["python"]