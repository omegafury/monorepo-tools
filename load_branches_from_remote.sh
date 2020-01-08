#!/usr/bin/env bash

# Delete all local branches and create all non-remote-tracking branches of a specified remote
#
# Usage: load_branches_from_remote.sh <remote-name> <build-branch>
#
# Example: load_branches_from_remote.sh origin master

REMOTE=$1
BUILD_BRANCH=$2
# echo "Loading all branches from the remote '$REMOTE' for build branch '$BUILD_BRANCH' (all local branches are deleted)"
# Checking out orphan commit so it 's possible to delete current branch
git checkout --orphan void
git rm -rf --cached .
git clean -fd
# Delete all local branches
for BRANCH in `git branch`; do
    git branch -D $BRANCH
done

echo "Initialzing $BUILD_BRANCH from $REMOTE/initializer"
git checkout $REMOTE/initializer
git checkout -b $BUILD_BRANCH

