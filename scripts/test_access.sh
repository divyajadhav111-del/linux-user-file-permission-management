#!/bin/bash
# Verifies the access model. Run as root: ./scripts/test_access.sh
BASE=/srv/project
check () {  # user, command, expected (allow|deny)
  if runuser -u "$1" -- bash -c "$2" >/dev/null 2>&1; then r=allow; else r=deny; fi
  [ "$r" = "$3" ] && s=PASS || s=FAIL
  printf "%-5s %-6s %-40s expected=%-5s got=%-5s\n" "$s" "$1" "$2" "$3" "$r"
}
check alice "touch $BASE/dev/a.txt"    allow
check bob   "cat $BASE/dev/a.txt"      allow
check carol "ls $BASE/dev"             deny
check carol "touch $BASE/test/c.txt"   allow
check alice "ls $BASE/test"            deny
check alice "touch $BASE/public/p.txt" allow
check carol "rm $BASE/public/p.txt"    deny
