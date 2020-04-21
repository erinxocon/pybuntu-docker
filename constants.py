from pathlib import Path

ROOT = Path(__file__).parent
TEMPLATES_DIR = ROOT / 'templates'
OUT = ROOT / 'out'

UBUNTU_VERSIONS = {'18.04': 'bionic', '20.04': 'focal'}

PYTHON_VERSIONS = {'2.7.18', '3.5.9', '3.6.10', '3.7.7', '3.8.2', '3.9.0a5'}

VERSIONS = ((u_ver, p_ver) for u_ver in UBUNTU_VERSIONS for p_ver in PYTHON_VERSIONS)

PIP_VERSION = '20.0.2'
