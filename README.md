# Linux User & File Permission Management

A hands-on project that builds a complete **user, group and file-permission model** on Linux using `useradd`, `groupadd`, `chown` and `chmod`. Developers and testers each get a private shared directory, and a public directory is protected with the sticky bit.

---

## Objective

Secure shared resources so that:
- Each team can read and write only its own directory.
- Users from other teams are denied access.
- A public directory is writable by everyone, but users can delete only their own files.

---

## Access Model

| User | Group | Directory | Access |
|---|---|---|---|
| alice | developers | `/srv/project/dev` | Read, write, execute |
| bob | developers | `/srv/project/dev` | Read, write, execute |
| carol | testers | `/srv/project/test` | Read, write, execute |
| carol | testers | `/srv/project/dev` | **Denied** |
| alice | developers | `/srv/project/test` | **Denied** |
| everyone | - | `/srv/project/public` | Write; delete own files only |

| Directory | Owner:Group | Mode | Why |
|---|---|---|---|
| `/srv/project/dev` | root:developers | `2770` | Group access only; setgid keeps new files in the `developers` group |
| `/srv/project/test` | root:testers | `2770` | Same, for the `testers` group |
| `/srv/project/public` | root:root | `1777` | Sticky bit stops users deleting each other's files |

---

## Concepts Used

- **Users and groups:** `useradd`, `groupadd`, `usermod`, `id`, `groups`
- **Ownership:** `chown user:group`
- **Permissions:** `chmod` in numeric (`770`) and symbolic (`g+rwx`) form
- **Special bits:** setgid (`2xxx`) and sticky bit (`1xxx`)
- **Principle of least privilege:** each user gets only the access they need

### Quick permission reference

| Number | Meaning |
|---|---|
| 7 | read + write + execute |
| 6 | read + write |
| 5 | read + execute |
| 4 | read only |
| 0 | no access |

Example: `770` means the owner and the group have full access and others have none.

---

## How to Run

> Use a test Linux machine or an EC2 instance (Amazon Linux or Ubuntu). The scripts create and delete users, so do not run them on a production server.

```bash
git clone https://github.com/divyajadhav111-del/linux-user-file-permission-management.git
cd linux-user-file-permission-management

sudo ./scripts/setup.sh        # creates groups, users, directories, permissions
sudo ./scripts/test_access.sh  # verifies who can and cannot access what
sudo ./scripts/cleanup.sh      # removes everything when finished
```

If the scripts are not executable, run `chmod +x scripts/*.sh` first.

---

## Sample Output

**setup.sh**
```
drwxrws--- 2 root developers 4096 Oct  3 12:40 /srv/project/dev
drwxrwxrwt 2 root root       4096 Oct  3 12:40 /srv/project/public
drwxrws--- 2 root testers    4096 Oct  3 12:40 /srv/project/test
```

**test_access.sh**
```
PASS  alice  touch /srv/project/dev/a.txt             expected=allow got=allow
PASS  bob    cat /srv/project/dev/a.txt               expected=allow got=allow
PASS  carol  ls /srv/project/dev                      expected=deny  got=deny
PASS  carol  touch /srv/project/test/c.txt            expected=allow got=allow
PASS  alice  ls /srv/project/test                     expected=deny  got=deny
PASS  alice  touch /srv/project/public/p.txt          expected=allow got=allow
PASS  carol  rm /srv/project/public/p.txt             expected=deny  got=deny
```

> Add your own screenshot here: `![Output](images/output.png)`

---

## Project Structure

```
├── scripts/
│   ├── setup.sh          # create users, groups, directories, permissions
│   ├── test_access.sh    # automated allow/deny checks
│   └── cleanup.sh        # remove everything
├── images/
└── README.md
```

---

## What I Learned

- How Linux ownership and the owner/group/other permission model work
- Using `chmod` and `chown` to control access to shared resources
- Why setgid is useful on shared team directories
- Why the sticky bit is used on public directories such as `/tmp`
- Testing a permission model instead of assuming it works

---

## Future Improvements

- Add ACLs (`setfacl`) for finer-grained access
- Add `sudo` rules to give limited admin rights
- Enforce password policies and SSH key-only login
- Run the setup automatically through EC2 User Data

---

## Author

**Divya Jadhav**
AWS Cloud Engineer (Fresher)
[LinkedIn](https://www.linkedin.com/in/divya-jadhav-4555752a6/) | [GitHub](https://github.com/divyajadhav111-del) | divyajadhav1011@gmail.com
