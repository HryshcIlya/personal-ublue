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
    #!/usr/bin/pkexec /usr/bin/bash
    POLICY_FILE="/etc/containers/policy.json"
    if [ ! -f "$POLICY_FILE" ]; then
        echo "Policy file not found: $POLICY_FILE"
        exit 1
    fi

    CURRENT_POLICY=$(jq -r '.default[] | select(.type == "insecureAcceptAnything" or .type == "reject") | .type' "$POLICY_FILE")

    if [ "$CURRENT_POLICY" == "insecureAcceptAnything" ]; then
        jq 'walk(if type == "object" and .type == "insecureAcceptAnything" then .type = "reject" else . end)' "$POLICY_FILE" | sudo tee "$POLICY_FILE" > /dev/null
        echo "Policy switched to reject."
    elif [ "$CURRENT_POLICY" == "reject" ]; then
        jq 'walk(if type == "object" and .type == "reject" then .type = "insecureAcceptAnything" else . end)' "$POLICY_FILE" | sudo tee "$POLICY_FILE" > /dev/null
        echo "Policy switched to insecureAcceptAnything."
    else
        echo "No matching policy found to toggle."
    fi