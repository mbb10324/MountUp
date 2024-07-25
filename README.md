<div align="center">
    <h1>MountUp</h1>
    <a href="https://github.com/mbb10324/MountUp/">
        <img src="https://raw.githubusercontent.com/mbb10324/MountUp/master/docs/MountUp-logo.png" alt="MountUp Logo" width="30%" />
    </a>
</div>

### About

The MountUp add-on provides various methods for summoning mounts, including random mounts, favorites, and more.

### Commands

-   `/MountUp`: Summon a random mount based off zone priority. If your in a flying zone, you will mount on a random flying/dragon riding mount, and if your in a ground zone, you will mount on a random ground or flying mount.

-   `/MountUpFav`: Summon a random favorite mount with zone priority. Select your favorites from the options menu. Favorites are saved by profile, so you can have unique favorites for each character, or just multiple different set ups.

-   `/MountUpFlying`: Summon a random flying/dragon riding mount.

-   `/MountUpGround`: Summon a random ground mount.

-   `/MountUpRandom`: Summon a random mount, regardless of zone.

-   `/MountUpOptions`: Opens the options menu for MountUp.

-   `/MountUpHelp`: Prints all of the avaliable MountUp commands to the chat window.

### Issues

With recent changes in 11.0.0 to the API, and the inclusion of all flying mounts being able to dragon ride, we have had to make some changes to our slash commands. You will notice the `/MountUpDragon` command has been removed, and now all dragon riding mounts will be treated as flying mounts. The API is changing with every update to the game specifically with mounts. If you have any issues with this change, please let us know!

If you find any issues with MountUp, please report them on our [MountUp GitHub Issues](https://github.com/mbb10324/MountUp/issues "MountUp GitHub Issues") page.

### Contributing

If you would like to contribute to MountUp:

1.  Read our [Code of Conduct](https://github.com/mbb10324/MountUp/tree/master/docs/code-of-conduct.md "MountUp Code of Conduct").
2.  Read our [Contributing Guidelines](https://github.com/mbb10324/MountUp/tree/master/docs/contributing.md "MountUp Contributing Guidelines").
3.  Clone the repository from the [MountUp GitHub](https://github.com/mbb10324/MountUp "MountUp Github").
4.  Start a new branch, make your changes, and submit a Pull Request.

#### Dependencies

MountUp uses `AceAddon-3.0` and `LibStub` to store and manage profiles.
