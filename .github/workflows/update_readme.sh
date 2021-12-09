#!/bin/bash

function update_readme(){
  echo "![commit image](commit.png)" > README.md
  for dir in `find skils -mindepth 1 -maxdepth 1 -type d`;
  do
    latest_md_file=`ls -rt $dir *.md | tail -n 1`
    echo "`cat $dir/$latest_md_file | sed -n '/---/q;p'`">>README.md
    echo "## 最新コミット">>README.md
    for i in $(seq 1 3); do
      commit_id=`git log -n $i --pretty=%h $dir | tail -n 1`
      commit_data=`git log -n $i --date=short --pretty=format:"%ad : %s" $dir | tail -n 1`
      echo "- [$commit_id](${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/commit/$commit_id) $commit_data">>README.md
    done
  done
}

cd `git rev-parse --show-toplevel`
update_readme
