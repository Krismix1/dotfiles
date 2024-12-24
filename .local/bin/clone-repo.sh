#!/usr/bin/env bash

set -eu

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <base_url>"
    exit 1
fi

repo_url="$1"
repo_name="${repo_url##*/}"

mkdir $repo_name
cd $repo_name
git clone "$repo_url" --bare .bare

echo -n "gitdir: ./.bare" > .git

# Check if the current directory is a Git repository
if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    echo "Error: This is not a Git repository."
    exit 1
fi
branch=$(git rev-parse --abbrev-ref HEAD)
# Determine the branch name
if [ "$branch" == "main" ]; then
    branch_name="main"
elif [ "$branch" == "master" ]; then
    branch_name="master"
else
    echo "Error: The branch name is not 'main' or 'master'."
    exit 1
fi

git worktree add "$branch_name" "$branch_name"

git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

cd "$branch_name"
git branch | grep -v "$branch_name" | xargs -- git branch -D
git fetch
git branch --set-upstream-to=origin/"$branch_name" "$branch_name"
git submodule update --recursive --init
