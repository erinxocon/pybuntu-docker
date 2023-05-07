from pathlib import Path

ROOT = Path(__file__).parent
TEMPLATES_DIR = ROOT / "templates"
OUT = ROOT / "out"

UBUNTU_VERSIONS = {"18.04": "bionic", "20.04": "focal", "22.04": "jammy"}

PYTHON_VERSIONS = {"3.7.16", "3.8.16", "3.9.16", "3.10.11", "3.11.3", "3.12.0a7"}

VERSIONS = ((u_ver, p_ver) for u_ver in UBUNTU_VERSIONS for p_ver in PYTHON_VERSIONS)

PIP_VERSION = "23.1.2"
