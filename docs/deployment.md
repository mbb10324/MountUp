# Deployment Process

1. Update code base with any appropriate changes, and check to ensure that our dependencies are up to date (see [taintless](https://www.townlong-yak.com/addons/), and [wowace](https://www.wowace.com/projects/ace3/)).

2. In `MountUp.toc` increment the version number appropriate with semver, ensure that the interface number matches the latest wow release number.

3. In the `/docs/change-log.md` file add a new entry for the latest version with a bulleted summary of changes.

4. Commit and push changes to master.

5. Within a folder titled `MountUp` add the following files:

    - `/Libs` (folder containing all dependencies)
    - `MountUp.lua`
    - `MountUp.toc`
    - `MountUp_Config.lua`
    - `MountUp_Favorites.lua`

6. On Windows right click the folder and select `Send to -> Compressed (zipped) folder`. On Mac right click the folder and select `Compress "MountUp"`.

7. Rename the zip file to `MountUp-vX.X.X.zip` where `X.X.X` is the version number.

8. Navigate to [CurseForge / MountUp - Better Mount Summoner](https://legacy.curseforge.com/wow/addons/mountup-better-mount-summoner/).

9. Click on the `File` button.

10. Under `Choose File` select the zip file created in step 6.

11. Under `Display Name` enter the name of zip file (excluding the `.zip`).

12. Under `Release Type` select `Release`.

13. Under `Changelog` change the editor from WYSIWYG to Markdown, and copy and paste the contents of `/docs/change-log.md`.

14. Select the latest Supported Game Version.

15. Click `Submit File`.

16. The review process will take a few minutes, and then the new version will be available for download.
