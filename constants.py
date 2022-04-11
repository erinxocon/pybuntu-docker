from pathlib import Path

ROOT = Path(__file__).parent
TEMPLATES_DIR = ROOT / "templates"
OUT = ROOT / "out"

UBUNTU_VERSIONS = {"18.04": "bionic", "20.04": "focal"}

PYTHON_VERSIONS = {"3.7.13", "3.8.13", "3.9.11", "3.10.3", "3.11.0a6"}

VERSIONS = ((u_ver, p_ver) for u_ver in UBUNTU_VERSIONS for p_ver in PYTHON_VERSIONS)

PIP_VERSION = "22.0.3"
