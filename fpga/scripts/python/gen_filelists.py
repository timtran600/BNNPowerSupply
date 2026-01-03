from pathlib import Path
import yaml

# ------------------------------------------------------------
# Constants
# ------------------------------------------------------------
ROOT = Path(__file__).parents[3].resolve()   # repo root
FPGA_ROOT = ROOT / "fpga"
BUILD_DIR = FPGA_ROOT / "build"

RTL_EXT = (".sv", ".v")
IP_EXT  = (".xci", ".xcix")
XDC_EXT = (".xdc",)

# ------------------------------------------------------------
# Load project configuration
# ------------------------------------------------------------
with open(FPGA_ROOT / "scripts/yaml/project.yaml", "r") as f:
    cfg = yaml.safe_load(f)

# ------------------------------------------------------------
# Helper: collect files by extension
# ------------------------------------------------------------
def collect_files(dirs, extensions):
    files = []
    for d in dirs:
        base = FPGA_ROOT / d
        if not base.exists():
            raise FileNotFoundError(f"Source directory not found: {base}")

        for path in sorted(base.rglob("*")):
            if path.suffix in extensions:
                files.append(path.resolve())

    return files

# ------------------------------------------------------------
# Collect sources
# ------------------------------------------------------------
rtl_files = collect_files(cfg["sources"]["rtl_dirs"], RTL_EXT)
ip_files  = collect_files(cfg["sources"].get("ip_dirs", []), IP_EXT)
xdc_files = collect_files(cfg["sources"].get("xdc_dirs", []), XDC_EXT)

# ------------------------------------------------------------
# Create build directory
# ------------------------------------------------------------
BUILD_DIR.mkdir(exist_ok=True)

# ------------------------------------------------------------
# Write Vivado-safe filelists
# Use absolute paths to avoid path resolution issues
# ------------------------------------------------------------
def write_flist(filename, files):
    flist_path = BUILD_DIR / filename

    with open(flist_path, "w") as f:
        for file in files:
            # Use absolute paths with forward slashes (Vivado requirement)
            abs_path = file.resolve().as_posix()
            f.write(abs_path + "\n")

    print(f"Generated {flist_path} ({len(files)} files)")

write_flist("rtl.f", rtl_files)
write_flist("ip.f",  ip_files)
write_flist("xdc.f", xdc_files)