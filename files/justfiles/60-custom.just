# Toggle between verified and all applications for Flathub
toggle-flathub-verified:
    #!/usr/bin/bash
    current_subset=$(flatpak remotes --user --columns=name,subset | grep flathub-verified | awk '{print $2}')

    if [ "$current_subset" == "verified" ]; then
        flatpak remote-modify flathub-verified --subset=
        echo "Switched to all applications"
    else
        flatpak remote-modify flathub-verified --subset=verified
        echo "Switched to verified applications only"
    fi