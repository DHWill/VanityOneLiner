#!/bin/bash
# Configuration
REPO_DIR="/home/pi/vanityOneLiner"   # local repository path
REMOTE_BRANCH="main"                 # remote branch 
SCRIPT_TO_RUN="/home/pi/vanityOneLiner/runCameraFullScreen.sh" # script to run
CHECK_INTERVAL=5

chmod +x $SCRIPT_TO_RUN
cd "$REPO_DIR" || { echo "Error: Repository directory does not exist."; exit 1; }

#check repo for changes pull if nescessary re-run script
check_repo() {
    # Fetch the latest changes from the remote repository
    git fetch origin "$REMOTE_BRANCH"
    # Check if there are any new commits
    LOCAL_COMMIT=$(git rev-parse HEAD)
    REMOTE_COMMIT=$(git rev-parse origin/"$REMOTE_BRANCH")
    if [ "$LOCAL_COMMIT" != "$REMOTE_COMMIT" ]; then
        echo "Changes detected in the remote repository."
        # Pull the latest changes
        git pull origin "$REMOTE_BRANCH" || { echo "Error: Failed to pull changes."; exit 1; }
        # Run the specified script
        if [ -x "$SCRIPT_TO_RUN" ]; then
            echo "Running script: $SCRIPT_TO_RUN"
            "$SCRIPT_TO_RUN"
        else
            echo "Error: Script $SCRIPT_TO_RUN is not executable."
            exit 1
        fi
    else
        echo "No changes detected in the remote repository."
    fi
}

#Always cehck 
while true; do
    echo "Checking repository for changes..."
    check_repo
    echo "Waiting for $CHECK_INTERVAL seconds before checking again..."
    sleep "$CHECK_INTERVAL"
done