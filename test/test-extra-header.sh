#!/usr/bin/env bash

. "test/testlib.sh"

begin_test "http.<url>.extraHeader"
(
  set -e

  reponame="copy-headers"
  setup_remote_repo "$reponame"
  clone_repo "$reponame" "$reponame"

  git config "http.$(git config remote.origin.url).extraHeader" "X-Foo: bar"
  git config "http.$(git config remote.origin.url).extraHeader" "X-Foo: baz"

  git lfs track "*.dat"
  printf "contents" > a.dat
  git add .gitattributes a.dat
  git commit -m "initial commit"

  GIT_CURL_VERBOSE=1 git push origin master 1>/dev/null 2>&1 | tee curl.log

  grep "X-Got-Header: X-Foo: bar" trace.log
  grep "X-Got-Header: X-Foo: baz" trace.log
)
end_test
