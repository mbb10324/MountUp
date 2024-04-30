MountUp-v1.0.8:

-   Instead of checking a `mountTypeID` for wether or not a mount is a dragon riding mount, we now check the new `isForDragonriding` boolean exposed by the API. This should allow for a more accurate check for dragon riding mounts.
-   Fixed a bug introduced in 10.2.6 where a dragonriding mount would always be summoned in a ground mount area with the `MountUpFav` and the `MountUp` slash commands.

MountUp-v1.0.7:

-   Verified all functionality with 10.2.6

MountUp-v1.0.6:

-   Verified all functionality with 10.2.5
-   Updated/Added documentation

MountUp-v1.0.5:

-   Fixed a bug when attempting to summon dragon riding mounts that would occasionally cause lua erros.
-   Added PLAYER_ENTERING_WORLD to the mount update list.

MountUp-v1.0.4:

-   Verified all functionality with 10.2
-   Previously you would have to /reload to update MountUp to be aware of a new mount after learning one. MountUp properly will now automatically update its lists when a new mount is learned.
-   Fixed a bug on the favorites tab when you searched for a mount and the "No Results Found" message was displayed, it would stay shown until a reload would occur.
-   Fixed a bug where the options frame would occasionally try to recreate itself after a reload.
-   Cleaned up the code base. Separated more logic out into functions, and updated documentation/comments.

MountUp-v1.0.3:

-   Standardized naming conventions for certain variables
-   Added check and print statement for the case when no favorites were selected
-   Altered logic to print messages when no usable mounts were found correctly
-   Altered logic to determine mount tables to cut down on loops and increase efficiency
-   Altered and cleaned up event handling logic and removed unncessary conditional block

MountUp-v1.0.2:

-   Cleaned up code base
-   Added documentation and better comments

MountUp-v1.0.1:

-   Initial Release
