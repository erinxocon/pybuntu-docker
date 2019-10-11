import os
from pathlib import Path

CURRENT_DIR = Path('.')
TEMPLATES_DIR = Path('templates/.')

INSTALL_BUILD_ESSENTIALS = '''
RUN apt-get update && apt-get install -y --no-install-recommends \\
        build-essentials
    && rm -rf /var/lib/apt/lists/*
'''

PIP_VERSION = '19.2.3'

images = {'ubuntu': ['18.04', '19.04']}

python_versions = [
    '2.7.16',
    '3.5.7',
    '3.6.9',
    '3.7.4',
    '3.8.0rc1',
    '3.7.5rc1',
    '3.5.8rc1',
    '2.7.17rc1',
]

for image, tags in images.items():
    for tag in tags:
        for version in python_versions:
            dfile = 'Dockerfile.python3' if version.startswith('3') else 'Dockerfile.python2'
            with open(TEMPLATES_DIR / dfile, encoding='utf-8') as f:
                dockerfile = f.read()

            folder = CURRENT_DIR / version
            os.makedirs(folder, exist_ok=True)

            with open(
                folder / f"Dockerfile.{tag.replace('.', '')}", mode='w', encoding='utf-8'
            ) as f:
                f.write(
                    dockerfile.format(
                        image=image,
                        tag=tag,
                        python_version=version,
                        pip_version=PIP_VERSION,
                        install_build_essentials='',
                    )
                )

            if tag == '18.04' and not any(x in version for x in ('rc', 'b', 'a')):
                with open(
                    folder / f"Dockerfile.{tag.replace('.', '')}.dev", mode='w', encoding='utf-8'
                ) as f:
                    f.write(
                        dockerfile.format(
                            image=image,
                            tag=tag,
                            python_version=version,
                            pip_version=PIP_VERSION,
                            install_build_essentials=INSTALL_BUILD_ESSENTIALS,
                        )
                    )
