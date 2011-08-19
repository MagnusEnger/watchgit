#!/bin/bash

# Move into the repository
cd repo

# Fetch all repos and get the names of new or changed branches
function fetchgit {
git fetch --all -v 2>&1      | \
    grep -v '\[up to date\]' | \
    grep -v '\[new tag\] '   | \
    grep ' -> '
}

IFS=$'\n'
for f in $( fetchgit ); do
  
  echo "f: $f"
  
  if [ $( echo "$f" | cut -c 4-15 ) = "[new branch]" ]
  then
    echo "new branch"
    #  * [new branch]      test2      -> libriotech/test2
    # Get the commits that differ from origin/master
    branch=$( echo "$f" | sed -n 's/.*-> \(.*\)/\1/p' )
    echo "branch: $branch"
    for id in $( git cherry remotes/origin/master "$branch" | cut -c 3- ); do
      echo "id: $id"
      git show --name-only "$id"
    done
  else
    echo "updated branch? $f"
    #    8273424..190aa4e  solr/ft/MT7189 -> biblibre/solr/ft/MT7189
    #    5673e32..d1bed88  wip/solr   -> biblibre/wip/solr
    # Pick out the ranges of commits that are new
    range=$( echo "$f" | cut -c 4-19 )
    git log --decorate "$range"
  fi
  
done

# TODO: Output RSS
# http://ocsovszki-dorian.blogspot.com/2011/01/generating-rss-feed-width-bash-script.html
