# Implémentation : iDkP from GaragePixel  
# Date : 2025-08-20

---

## Purpose

Import a GitHub project (folder or set of files) into a subfolder of another repository **while preserving the full history** (log, blame, merges)

---

## List of functionality

- Clone the source repo as a bare repository (no working tree, so no Windows errors)
- Use `git-filter-repo.py` to move the entire history into a target subfolder
- Add this filtered bare repository as a remote in the destination repo
- Merge the history into the current branch
- Compatible with folders, files, and multiple sources
- Works on Windows, macOS, and Linux

---

## Notes section explaining implementation choices

- **Bare repo**: avoids checkout, so no errors about forbidden names (Windows, NTFS)
- **git-filter-repo**: acts on the bare repo, so all paths/names are compatible
- **Merge with --allow-unrelated-histories**: imports the entire history, even if the projects are unrelated
- **No need for sparse-checkout, subtree split/add**: more robust for NTFS cases

---

## Technical advantages, detailed explanations

- **100% history preservation**: all commits, authors, dates, and merges are preserved
- **No parsing/checkout bugs**: because we work on the bare script, never on the Windows working tree
- **Multi-use**: you can adapt it for any project, folder, or file
- **Native Windows batch script**: easy to automate, with no exotic dependencies
- **Fast**: no checkout, no manual manipulation
- **Easy to adapt**: just change the paths/URLs at the top of the script

**This template works for all your cases:
You simply adjust the path variables and you can import any project/folder/file with its full history.**

---
## Generic version of the script

```
@echo off
REM Implémentation : iDkP from GaragePixel, 2025-08-20

REM ---- USER EDITABLE PATHS ----
set "FILTER_REPO_SCRIPT=..\git-filter-repo.py"
set "SRC_URL=https://github.com/owner/source-repo.git"
set "SRC_BARE=source_bare.git"
set "DST_REPO=..\destination_repo"
set "TARGET_SUBDIR=subfolder/where/you/want/history"

REM ---- STEP 1: Clone source repo as bare ----
git clone --mirror "%SRC_URL%" "%SRC_BARE%"
if errorlevel 1 (
	echo Failed to clone source repo.
	exit /b 1
)

REM ---- STEP 2: Move everything into subdir using git-filter-repo.py ----
cd "%SRC_BARE%"
python "%FILTER_REPO_SCRIPT%" --to-subdirectory-filter "%TARGET_SUBDIR%"
if errorlevel 1 (
	echo git-filter-repo.py failed.
	cd ..
	exit /b 1
)
cd ..

REM ---- STEP 3: Add filtered source as remote to destination repo ----
cd "%DST_REPO%"
git remote add src_bare "..\%SRC_BARE%"
git fetch src_bare
if errorlevel 1 (
	echo Failed to fetch from src_bare remote.
	exit /b 1
)

REM ---- STEP 4: Merge history into current branch ----
git merge --allow-unrelated-histories --no-commit src_bare/master
if errorlevel 1 (
	echo Merge failed. Please resolve conflicts manually.
	exit /b 1
)

echo -------------------------------------------------------------
echo SUCCESS! Source history now in %TARGET_SUBDIR% with full history.
echo Review changes, resolve any conflicts and commit as needed.
echo To finalize, push your branch up to GitHub.
```
