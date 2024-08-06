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

# Toggle container policy between insecureAcceptAnything and reject
toggle-container-policy:
    #!/usr/bin/bash
    POLICY_FILE="/usr/etc/containers/policy.json"

    if [ ! -f "$POLICY_FILE" ]; then
        echo "Error: $POLICY_FILE does not exist."
        exit 1
    fi

    current_policy=$(grep -oP '(?<="default": \[{"type": ")[^"]*' "$POLICY_FILE")

    if [ "$current_policy" == "insecureAcceptAnything" ]; then
        sudo sed -i 's/"default": \[{"type": "insecureAcceptAnything"}\]/"default": [{"type": "reject"}]/' "$POLICY_FILE"
        echo "Policy changed from insecureAcceptAnything to reject"
    elif [ "$current_policy" == "reject" ]; then
        sudo sed -i 's/"default": \[{"type": "reject"}\]/"default": [{"type": "insecureAcceptAnything"}]/' "$POLICY_FILE"
        echo "Policy changed from reject to insecureAcceptAnything"
    else
        echo "Current policy is neither insecureAcceptAnything nor reject. Manual check required."
        exit 1
    fi

    new_policy=$(grep -oP '(?<="default": \[{"type": ")[^"]*' "$POLICY_FILE")
    echo "New policy is: $new_policy"