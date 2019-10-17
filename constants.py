from pathlib import Path

ROOT = Path(__file__).parent
TEMPLATES_DIR = ROOT / 'templates'
OUT = ROOT / 'out'

UBUNTU_VERSIONS = {'18.04': 'bionic', '19.04': 'disco'}

PYTHON_VERSIONS = {'2.7.16', '3.5.7', '3.6.9', '3.7.5', '3.8.0', '2.7.17rc1', '3.5.8rc2'}

VERSIONS = ((u_ver, p_ver) for u_ver in UBUNTU_VERSIONS for p_ver in PYTHON_VERSIONS)
