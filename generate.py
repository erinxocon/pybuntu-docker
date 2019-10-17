from jinja2 import Template

from constants import OUT, TEMPLATES_DIR, UBUNTU_VERSIONS, VERSIONS

INSTALL_BUILD_ESSENTIALS = r'''
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essentials \
    && rm -rf /var/lib/apt/lists/*
'''

PYTHON_BASE_DEPS = [
    'dpkg-dev',
    'gcc',
    'libbz2-dev',
    'libc6-dev',
    'libgdbm-dev',
    'libncursesw5-dev',
    'libreadline-dev',
    'libsqlite3-dev',
    'libssl-dev',
    'make',
    'wget',
    'xz-utils',
    'zlib1g-dev',
]

PYTHON2_DEPS = PYTHON_BASE_DEPS + ['libdb-dev']

PYTHON3_DEPS = PYTHON_BASE_DEPS + [
    'libexpat1-dev',
    'libffi-dev',
    'liblzma-dev',
    'tk-dev',
    'uuid-dev',
]

PROFILE_TASKS = [
    'test_array',
    'test_base64',
    'test_binascii',
    'test_binhex',
    'test_binop',
    'test_bytes',
    'test_c_locale_coercion',
    'test_class',
    'test_cmath',
    'test_codecs',
    'test_compile',
    'test_complex',
    'test_csv',
    'test_decimal',
    'test_dict',
    'test_float',
    'test_fstring',
    'test_hashlib',
    'test_io',
    'test_iter',
    'test_json',
    'test_long',
    'test_math',
    'test_memoryview',
    'test_pickle',
    'test_re',
    'test_set',
    'test_slice',
    'test_struct',
    'test_threading',
    'test_time',
    'test_traceback',
    'test_unicode',
]

PIP_VERSION = '19.2.3'

PIP_URL = 'https://github.com/pypa/get-pip/raw/309a56c5fd94bd1134053a541cb4657a4e47e09d/get-pip.py'


with (TEMPLATES_DIR / 'Dockerfile-caveman.j2').open(mode='r', encoding='utf-8') as f:
    PYTHON2_TEMPLATE = Template(f.read())

with (TEMPLATES_DIR / 'Dockerfile.j2').open(mode='r', encoding='utf-8') as f:
    PYTHON3_TEMPLATE = Template(f.read())


def generate_dockerfiles():

    for u_ver, p_ver in VERSIONS:
        context_args = {
            'tag': u_ver,
            'python_version': p_ver,
            'apt_deps': PYTHON3_DEPS,
            'profile_tasks': PROFILE_TASKS,
            'pip_version': PIP_VERSION,
            'pip_url': PIP_URL,
            'install_build_essential': '',
        }

        t = PYTHON3_TEMPLATE if p_ver.startswith('3') else PYTHON2_TEMPLATE

        dest = OUT / p_ver / UBUNTU_VERSIONS[u_ver]
        dest.mkdir(exist_ok=True, parents=True)

        with (dest / 'Dockerfile').open(mode='w', encoding='utf-8') as f:
            f.write(t.render(**context_args))

        if u_ver == '18.04':
            dev_dest = dest / 'dev'
            dev_dest.mkdir(exist_ok=True)
            with (dev_dest / 'Dockerfile').open(mode='w', encoding='utf-8') as f:
                context_args['install_build_essential'] = INSTALL_BUILD_ESSENTIALS
                f.write(t.render(**context_args))


if __name__ == '__main__':
    generate_dockerfiles()
