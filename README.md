This repository stores the diff for Touhou game update. ZUN's executable touhou game patch are notoriously hard to run and use, due to needing Japanese system locale and sometimes directory picker dialog in Japanese that is difficult to understand. I make the diff to redistribute it for anybody to easily patch their copy of Touhou games.

## Diff Procedure
Starts with the original ver 1.00 directory for each game (or the oldest patchable version that is available).

1. Recursively rename all file extension to lowercase
2. Create a copy of the game directory to be patched
3. Drop ZUN executable patch into game directory
4. Run ZUN executable patch through WINE 32-bit (with `LC_ALL=ja_JP.UTF-8`)
5. Remove ZUN executable patch from the game directory
6. Generate diff via `diff -Naur before-patch/ after-patch/ > name_of_patch.diff`

The diff file should be named after the name of the ZUN executable patch minus the `.exe` extension. For example, changes made by running `kouma_update102f.EXE` should make the resulting diff be named `kouma_update102f.diff`. Normalization of diff file naming like this allows for search or listing of diff files to yield a correct order to apply patches.

This process is repeated between each patch stage until the latest version is reached. Contributors should follow the same procedure.

## Patch Procedure
Only apply to original game directory, pre-patched one may not work! Open `readme.txt` to see what game version you currently have and determine what diff to use to patch your game to the latest version. To apply patch, simply dry-run:
```
patch -Np1 --no-backup-if-mismatch -d directory_to_apply_the_patch_on/ --dry-run < patch_to_apply.diff
```
When the set of flags above is used, it will automatically skip invalid or previously applied patch file, only leaving reject files. Thus, it is safe to use this command even on wrong diff without dry run. If the patch applies cleanly, remove the `--dry-run` flag and re-run the command.

In case there were bad patches applied and it left a bunch of reject files, simply run this command to clean up:
```
find directory_with_bad_patch/ -name '*.rej' -exec rm {} \;
```

TODO:
- Add snippet for recursive renaming lowercase extension
- Find good way to automate applying all patch in-order, and only apply if the entire patch applies cleanly
- Wrap all of patch procedure automation into a script
