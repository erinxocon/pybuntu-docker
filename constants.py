from pathlib import Path

ROOT = Path(__file__).parent
TEMPLATES_DIR = ROOT / "templates"
OUT = ROOT / "out"

UBUNTU_VERSIONS = {"18.04": "bionic", "20.04": "focal", "22.04": "jammy"}

PYTHON_VERSIONS = {"3.7.17", "3.8.18", "3.9.18", "3.10.12", "3.11.5", "3.12.0rc2"}

VERSIONS = ((u_ver, p_ver) for u_ver in UBUNTU_VERSIONS for p_ver in PYTHON_VERSIONS)

PIP_VERSION = "23.2.1"
