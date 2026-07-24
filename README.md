# .bashrc
The point of this repository is to help set up Ubuntu `.bashrc` profiles with utilities I've generally found useful.

There are two entry points:
- `default-bashrc.bash` for WSL (includes Windows-specific helpers)
- `ubuntu-bashrc.bash` for native Ubuntu (skips Windows-specific helpers)

# New WSL install instructions:
1. Create SSH keys
2. Clone this repo
3. Replace the content of your `~/.bashrc` with the content of `default-bashrc.bash`.
4. Edit the variables in `~/.bashrc` to match your system preferences.
5. Run `installOrUpdateAllCliTools` and follow the instructions of any prompts
6. Consider running scripts starting `setup`.

# Native Ubuntu install instructions:
1. Create SSH keys
2. Clone this repo
3. Replace the content of your `~/.bashrc` with the content of `ubuntu-bashrc.bash`.
4. Edit the variables in `~/.bashrc` to match your system preferences.
5. Run `installOrUpdateAllCliTools` and follow the instructions of any prompts
6. Consider running scripts starting `setup`.