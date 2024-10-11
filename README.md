This repository stores the diff for Touhou game update. ZUN's executable touhou game patch are notoriously hard to run and use, due to needing Japanese system locale and sometimes directory picker dialog in Japanese that is difficult to understand. I make the diff and instructions redistributable it for anybody to easily patch their copy of Touhou games.

# Diff Procedure
Starts with the original ver 1.00 directory for each game (or the oldest patchable version that is available).

1. Recursively rename all file extension to lowercase
2. Create a copy of the game directory to be patched
3. Drop ZUN executable patch into game directory
4. Run ZUN executable patch through WINE 32-bit (with `LC_ALL=ja_JP.UTF-8`)
5. Remove ZUN executable patch from the game directory
6. Generate diff via `diff -Naur before-patch/ after-patch/ > name_of_patch.diff`

The diff file should be named after the name of the ZUN executable patch minus the `.exe` extension. For example, changes made by running `kouma_update102f.EXE` should make the resulting diff be named `kouma_update102f.diff`. Normalization of diff file naming like this allows for search or listing of diff files to yield a correct order to apply patches.

This process is repeated between each patch stage until the latest version is reached. Contributors should follow the same procedure.

# Patch Procedure
Only applies if you have the original JP game directory, pre-patched one may not work!

### Using git apply
The simplest procedure is using `git apply`, note that you need to be in the game directory before running command:
```
git apply /path/to/patch_to_apply.diff
```
You can also do a glob pattern to a directory containing diff files. Due to naming convention, this should always apply patch in the correct order.
```
git apply dir_containing_diff_files/*.diff
```

### Using GNU patch
Another alternative procedure not using `git apply` but with GNU patch instead.
Open `readme.txt` to see what game version you currently have and determine what diff to use to patch your game to the latest version. To apply patch, simply dry-run:
```
patch -Np1 --no-backup-if-mismatch -d dir_to_apply_patch_onto/ --dry-run < patch_to_apply.diff
```
When the set of flags above is used, it will automatically skip invalid or previously applied patch file, only leaving reject files. Thus, it is safe to use this command even on wrong diff without dry run. If the patch applies cleanly, remove the `--dry-run` flag and re-run the command.

In case there were bad patches applied and it left a bunch of reject files, simply run this command to clean up:
```
find directory_with_bad_patch/ -name '*.rej' -exec rm {} \;
```

### Windows
You need to install Git for Windows (https://git-scm.com/downloads/win). This gives two things that is needed:
- `git apply` and optionally GNU patch
- Bash shell
Commands involving `git apply` will also works on Windows through the Git Bash terminal. This is the recommended way.

If you choose use GNU patch then you must add `--binary` flag like so to ignore different line endings:
```
patch -Np1 --no-backup-if-mismatch --binary -d dir_to_apply_patch_onto/ --dry-run < patch_to_apply.diff
```


TODO:
- Add snippet for recursive renaming lowercase extension
- Find good way to automate applying all patch in-order, and only apply if the entire patch applies cleanly
- Wrap all of patch procedure automation into a script
