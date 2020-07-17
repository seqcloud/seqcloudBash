#!/usr/bin/env bash

# FIXME Prompt the user about this one.
koopa::macos_force_reset_icloud_drive() { # {{{1
    # """
    # Force reset iCloud Drive.
    #
    # iCloud Drive is located here:
    # ~/Library/Mobile\ Documents/com~apple~CloudDocs
    #
    # Check your Internet connection.
    # Go into iCloud settings and turn off iCloud Drive.
    # Then log out of iCloud.
    # Reboot.
    #
    # Close safari.
    # Nuke the old Safari bookmarks.
    # Note that this will remove the reading list.
    # > rm /Users/mike/Library/Safari/Bookmarks.plist 
    # > rm -rf /Users/mike/Library/Safari/CloudBookmarksMigrationCoordinator
    #
    # > sudo brctl log --wait --shorten
    # error while reading logs: <NSError:0x7fd360d01990(NSPOSIXErrorDomain:5)

    # Remove bird?
    # > sudo launchctl remove com.apple.bird
    # """
    koopa::assert_has_no_args "$#"
    sudo killall bird
    rm -fr "${HOME}/Library/Application Support/CloudDocs"
    rm -fr "${HOME}/Library/Caches/"*
    sudo reboot now
    return 0
}

