#!/bin/bash

# Script to copy and replace files from one path in the repo to another repo
# Declare the source_root_path and destination_root_path provided below
# run the command sh promoteChanges.sh hrportal/ui.apps or sh promoteChanges.sh hrportal/core or sh promoteChanges.sh dispatcher.ams
# so this would copy the files from soure and replace the content in the destination path
# This script will also let the user to see the difference in the files post copy/replace step and upon the user response, will let the user commit and push the changes as well

SOURCE_REPO_PATH="C:/Users/srikanta/Documents/repo/bitbucket/repo_1"
DESTINATION_REPO_PATH="C:/Users/srikanta/Documents/GitHub/repo_01"


if [ "$#" -eq 2 ]; then
    SOURCE_BRANCH=$1
    DESTINATION_BRANCH=$1
    PATH_TO_CASCADE=$2
elif [ "$#" -eq 3 ]; then
    SOURCE_BRANCH=$1
    DESTINATION_BRANCH=$2
    PATH_TO_CASCADE=$3
else
    echo "\n Invalid set of input arguments..."
fi



cd $SOURCE_REPO_PATH
git checkout $SOURCE_BRANCH
echo "Updating source .."
git fetch && git pull
cd $DESTINATION_REPO_PATH
git checkout $DESTINATION_BRANCH
echo "Updating destination .."
git fetch && git pull
echo "Destination - Clearing files from repo.."
rm -rf $DESTINATION_REPO_PATH/$PATH_TO_CASCADE/*
cp -rf $SOURCE_REPO_PATH/$PATH_TO_CASCADE/* $DESTINATION_REPO_PATH/$PATH_TO_CASCADE
cd $DESTINATION_REPO_PATH
git status
read -n 1 -p "Destination - Wouldyou like to see Git Difference of all the files (y/n).." gitinput
if [ "$gitinput" = "y" ]; then
        echo "\nDestination - Showing difference of the files added..."
        git diff .
elif [ "$gitinput" = "n" ]; then
        echo "\nDestination - moving on to commit step ....."
else
        echo "\nInvalid input .... moving on to Next step..."
        exit 1
fi
read -n 1 -p "Destination - Proceed with commit (y/n).." commitinput
if [ "$commitinput" = "y" ]; then
        echo "\nDestination - Commiting files......"
        git add .
        git commit -m "Cascading changes from Source Git Repo to Destination Git Repo"
elif [ "$commitinput" = "n" ]; then
        echo "\nExiting..."
        exit 0
else
        echo "\nInvalid input...moving onto Next Step"
        exit 1
fi
read -n 1 -p "Proceed with push (y/n).." pushinput
if [ "$pushinput" = "y" ]; then
        echo "\nPushing all the changes......"
        git push
        git status
        echo "\nExiting....."
        exit 0
elif [ "$pushinput" = "n" ]; then
        echo "\nExiting ..."
        exit 0
else
        echo "\nInvalid input..Exiting..."
        exit 1
fi
