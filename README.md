This repository stores the diff for Touhou game update. ZUN's executable touhou game patch are notoriously hard to run and use, due to needing Japanese system locale and sometimes directory picker dialog in Japanese that is difficult to understand. I make the diff to redistribute it for anybody to easily patch their copy of Touhou games.

## Procedure
Starts with the original ver 1.00 directory for each game (or the oldest patchable version that I could find).

1. Create a copy of the game directory to be patched
2. Drop ZUN executable patch are dropped into game directory
3. Run ZUN executable patch through WINE 32-bit (with `LC_ALL=ja_JP.UTF-8`)
4. Remove ZUN executable patch from the game directory
5. Generate diff via `diff -Naur before-patch/ after-patch/ > name_of_patch.diff`

The diff file should be named after the name of the ZUN executable patch minus the `.exe` extension. For example, changes made by running `kouma_update102f.EXE` should make the resulting diff be named `kouma_update102f.diff`. Normalization of diff file naming like this allows for search or listing of diff files to yield a correct order to apply patches.

This process is repeated between each patch stage until the latest version is reached. Contributors should follow the same procedure.

## Patch procedure
Only apply to original game directory, pre-patched one may not work! Open `readme.txt` to see what game version you currently have and determine what diff to use to patch your game to the latest version. To apply patch, simply run:
```
patch --directory=directory_to_apply_the_patch_on/ --strip=1 --forward < patch_to_apply.diff
```
When the `--forward` or `-N` flag is used, it will automatically skip invalid or previously applied patch file, only leaving behind backup and reject files. Thus, it is safe to use this command even on wrong diff.

If you want to clean up the backup and reject files, simply run this command within the game directory `find . -name '*.rej' -o -name '*.orig' -exec rm {} \;`

## Caveats
For contributors, it is important that you get original game directory with every assets in it. Some distributed copies may have intentionally removed original game asset, for example .bmp images to trim down size. Changes like this will carry into the diff and when the patch is applied, it will also remove those files.
