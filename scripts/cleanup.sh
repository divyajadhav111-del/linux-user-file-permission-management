#!/bin/bash
# Removes everything created by setup.sh. Run as root.
for u in alice bob carol; do userdel -r "$u" 2>/dev/null; done
for g in developers testers; do groupdel "$g" 2>/dev/null; done
rm -rf /srv/project
echo "Cleaned up."
