#!/bin/bash
# Configuration
REPO_DIR="/home/pi/VanityOneLiner"   # local repository path
REMOTE_BRANCH="main"                 # remote branch 
SCRIPT_TO_RUN="/home/pi/VanityOneLiner/runCameraFullScreen.sh" # script to run
SCRIPT_TO_RUN_COPY="/home/pi/runCameraFullScreen.sh" # script to run
CHECK_INTERVAL=5

chmod +x $SCRIPT_TO_RUN_COPY
cd "$REPO_DIR" || { echo "Error: Repository directory does not exist."; exit 1; }

#run script on start 
#bash "$SCRIPT_TO_RUN" &

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
        git pull origin "$REMOTE_BRANCH" || { echo "Error: Failed to pull changes."; }
        
        cp $SCRIPT_TO_RUN $SCRIPT_TO_RUN_COPY
        echo "Copying cameraScript to runtime"

        # Run the specified script
        bash "$SCRIPT_TO_RUN_COPY" &
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