#!/usr/bin/env python3
"""
Project #5 – Folder and File Creation in Python
Author: Ahmed, Irfan
OS: macOS (Apple Silicon)

Description:
    Asks the user for a folder name to create in the current working directory.
    If the folder already exists, it is removed and recreated. Then, the program
    generates 100 random integers in the range [0, 1000] and writes them to a
    file named "numbers100.txt" inside the created folder.

Notes:
    This implementation uses the standard library modules `os`, `shutil`, and
    `pathlib` which perform operating system calls to check for the folder,
    remove it, and create it in a cross‑platform way.
"""
from __future__ import annotations

import shutil
from pathlib import Path
import random
import sys

INVALID_NAME_CHARS = set('<>:"/\\|?*')  # common forbidden characters on many filesystems

def prompt_folder_name() -> str:
    """Prompt the user for a valid folder name."""
    while True:
        name = input("Enter the name of the folder to create in the current directory: ").strip()
        if not name:
            print("Folder name cannot be empty. Try again.\n"); continue
        if any(ch in INVALID_NAME_CHARS for ch in name):
            print('Please avoid using any of these characters in the name: <>:"/\\|?*\n'); continue
        return name

def recreate_folder(base_dir: Path, folder_name: str) -> Path:
    """Remove existing folder/file and create a fresh folder."""
    target = base_dir / folder_name
    if target.exists():
        if target.is_dir():
            print(f"Folder '{folder_name}' already exists. Removing it...")
            shutil.rmtree(target)
        else:
            print(f"A file named '{folder_name}' exists. Deleting it...")
            target.unlink()
    print(f"Creating folder '{folder_name}'...")
    target.mkdir(parents=True, exist_ok=False)
    return target

def write_random_numbers(dest_dir: Path,
                         count: int = 100,
                         low: int = 0,
                         high: int = 1000,
                         filename: str = "numbers100.txt") -> Path:
    """Generate random integers and write them to a text file (one per line)."""
    rng = random.SystemRandom()
    numbers = (str(rng.randrange(low, high + 1)) for _ in range(count))
    out_path = dest_dir / filename
    out_path.write_text("\n".join(numbers) + "\n", encoding="utf-8")
    return out_path

def main() -> int:
    print("=== Project #5: Folder and File Creation in Python ===")
    cwd = Path.cwd()
    print(f"Current working directory: {cwd}")
    folder_name = prompt_folder_name()
    try:
        target_dir = recreate_folder(cwd, folder_name)
        out_file = write_random_numbers(target_dir)
    except PermissionError as e:
        print(f"Permission error: {e}", file=sys.stderr); return 1
    except OSError as e:
        print(f"OS error: {e}", file=sys.stderr); return 1
    print(f"Success! Wrote 100 random numbers to: {out_file}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
