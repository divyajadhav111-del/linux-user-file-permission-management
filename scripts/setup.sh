#!/bin/bash
# Linux User & File Permission Management - setup script
# Run as root: sudo ./scripts/setup.sh
set -e

BASE=/srv/project

echo "[1/5] Creating groups..."
for g in developers testers; do
  getent group "$g" >/dev/null || groupadd "$g"
done

echo "[2/5] Creating users..."
useradd -m -s /bin/bash -G developers alice 2>/dev/null || true
useradd -m -s /bin/bash -G developers bob   2>/dev/null || true
useradd -m -s /bin/bash -G testers    carol 2>/dev/null || true

echo "[3/5] Creating shared directories..."
mkdir -p $BASE/dev $BASE/test $BASE/public

echo "[4/5] Setting ownership (chown)..."
chown root:developers $BASE/dev
chown root:testers    $BASE/test
chown root:root       $BASE/public

echo "[5/5] Setting permissions (chmod)..."
chmod 2770 $BASE/dev      # rwx for owner+group, none for others, setgid keeps group
chmod 2770 $BASE/test
chmod 1777 $BASE/public   # everyone can write, sticky bit: only owners delete own files

echo "Done. Current permissions:"
ls -ld $BASE/dev $BASE/test $BASE/public
