"""
Remove build artifacts and caches from the project tree.
"""

import argparse
import shutil
from pathlib import Path

PROJECT_DIR: Path = Path(__file__).resolve().parent.parent

GLOB_DIRS: list[str] = [
    "**/__pycache__",
    "**/*.egg-info",
    "**/.pytest_cache",
]

GLOB_FILES: list[str] = [
    "**/*.pyc",
]

DIRECT_PATHS: list[str] = [
    ".coverage",
    "htmlcov",
]


def remove_dirs(pattern: str) -> None:
    for path in PROJECT_DIR.glob(pattern):
        if path.is_dir():
            shutil.rmtree(path, ignore_errors=True)
            print(f"  removed dir:  {path}")


def remove_files(pattern: str) -> None:
    for path in PROJECT_DIR.glob(pattern):
        if path.is_file():
            path.unlink()
            print(f"  removed file: {path}")


def remove_direct(name: str) -> None:
    path: Path = PROJECT_DIR / name
    if path.is_dir():
        shutil.rmtree(path, ignore_errors=True)
        print(f"  removed dir:  {path}")
    elif path.is_file():
        path.unlink()
        print(f"  removed file: {path}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Clean project artifacts")
    parser.add_argument("--node", action="store_true", help="Remove node_modules/")
    parser.add_argument("--venv", action="store_true", help="Remove .venv/")
    args = parser.parse_args()

    if args.node:
        remove_direct("node_modules")
    elif args.venv:
        remove_direct(".venv")
    else:
        for pattern in GLOB_DIRS:
            remove_dirs(pattern)

        for pattern in GLOB_FILES:
            remove_files(pattern)

        for name in DIRECT_PATHS:
            remove_direct(name)
