# M(y)Arch 
A Bash based system customization script for Arch Linux.

# Examples

Generate a local repository folder:
```bash
march repo create /path/to/repo/i686
```

Update a repo's package database:
```bash
march repo update /path/to/repo/x86_64
```

Add package list(s) to a repo:
```bash
march list add /path/to/repo/i686 base base-extras
```

Remove package list(s) from a repo:
```bash
march list remove repo/x86_64 base-extras
```
