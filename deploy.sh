#!/bin/bash

# Exit on any error
set -e

# Remove old builds of hugo site
rm -rf public

# Build hugo site
./hugo

# Import all enviroment variables from .env file if it exists
set -o allexport
[[ -f .env ]] && source .env
set +o allexport

# Check if all enviroment variables needed to deploy site are set, if not, skip upload
if [ -z "$LFTP_PASSWORD" ]
then
    echo "LFTP_PASSWORD environment variable is not set, skipping upload"
elif [ -z "$LFTP_USER" ]
then
    echo "LFTP_USER environment variable is not set, skipping upload"
elif [ -z "$LFTP_HOST" ]
then
    echo "LFTP_HOST environment variable is not set, skipping upload"
elif [ -z "$LFTP_PORT" ]
then
    echo "LFTP_PORT environment variable is not set, skipping upload"
elif [ -z "$LFTP_PATH" ]
then
    echo "LFTP_PATH environment variable is not set, skipping upload"
else
    echo "Uploading site to server from $PWD/public to $LFTP_PATH on $LFTP_HOST:$LFTP_PORT as $LFTP_USER"

    # we start first by removing all previously uploaded files and directories from server
    # as LFTP doesn't support recursive removal of files and directories, 
    # we start first by list all files and directories on server
    # and then remove them one by one
    lftp --env-password sftp://$LFTP_USER@$LFTP_HOST:$LFTP_PORT -e "cls $LFTP_PATH; quit" > server_contents.txt

    # remove one-by-one all files and directories on server contained in local server_contents.txt file
    while read -r line; do
        if [[ $line == *"$LFTP_PATH"* ]]; then
            echo "Removing $line from server"
            lftp --env-password sftp://$LFTP_USER@$LFTP_HOST:$LFTP_PORT -e "rm -rf $line; quit"
        fi
    done < server_contents.txt

    # check if all the files were removed
    echo "Checking if all files were removed"
    lftp --env-password sftp://$LFTP_USER@$LFTP_HOST:$LFTP_PORT -e "cls -al $LFTP_PATH; quit"

    # upload all files and directories from local public/ directory to server
    lftp --env-password sftp://$LFTP_USER@$LFTP_HOST:$LFTP_PORT -e "mirror -R public/ $LFTP_PATH; quit"
    
    echo "Checking if all files were created"
    lftp --env-password sftp://$LFTP_USER@$LFTP_HOST:$LFTP_PORT -e "cls -al $LFTP_PATH; quit"

    # at first glance it may look like that the mirror command should do the job, but unfortunately it doesn't
    # all the uploaded files with get null permissions for "others" (0x640 for files and 0x750 for directories)
    # to be able to serve the page we need to change the permissions of all files and directories to 0x644 and 0x755 respectively
    # again, LFTP doesn't support recursive chmod, so we need to do it one by one, separately for files and directories
    cd public
    find . -type f -exec lftp --env-password sftp://$LFTP_USER@$LFTP_HOST:$LFTP_PORT -e "chmod o+r $LFTP_PATH{}; quit" \;
    find . -type d -exec lftp --env-password sftp://$LFTP_USER@$LFTP_HOST:$LFTP_PORT -e "chmod o+rx $LFTP_PATH{}; quit" \;
    cd ..

    echo "Checking if all files were created with proper permissions"
    lftp --env-password sftp://$LFTP_USER@$LFTP_HOST:$LFTP_PORT -e "cls -al $LFTP_PATH; quit"

fi
