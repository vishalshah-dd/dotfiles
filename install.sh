#!/usr/bin/env bash
# ensure you set the executable bit on the file with `chmod u+x install.sh`

# If you remove the .example extension from the file, once your workspace is created and the contents of this
# repo are copied into it, this script will execute.  This will happen in place of the default behavior of the workspace system,
# which is to symlink the dotfiles copied from this repo to the home directory in the workspace.
#
# Why would one use this file in stead of relying upon the default behavior?
#
# Using this file gives you a bit more control over what happens.
# If you want to do something complex in your workspace setup, you can do that here.
# Also, you can use this file to automatically install a certain tool in your workspace, such as vim.
#
# Just in case you still want the default behavior of symlinking the dotfiles to the root,
# we've included a block of code below for your convenience that does just that.

set -euo pipefail

DOTFILES_PATH="$HOME/dotfiles"

# Symlink dotfiles to the root within your workspace
find $DOTFILES_PATH -type f -path "$DOTFILES_PATH/.*" |
while read df; do
  link=${df/$DOTFILES_PATH/$HOME}
  mkdir -p "$(dirname "$link")"
  ln -sf "$df" "$link"
done

sudo apt-get update

#Claude plugins
claude plugin marketplace add anthropics/claude-code

# Datadog plugins
claude plugin marketplace add DataDog/claude-marketplace
claude plugin install marketplace-auto-update@datadog-claude-plugins --scope user
claude plugin install dd@datadog-claude-plugins --scope user
claude plugin install osx-notifications@datadog-claude-plugins --scope user
# while this plugin is recommended, it seems like atlassian mcp was pre-installed
# claude plugin install atlassian-remote-mcp@datadog-claude-plugins --scope user

# Install superclaude and mcps
PIPX_HOME=/home/bits/.local pipx_bin_dir=/home/bits/.local/bin pipx install superclaude
superclaude install
superclaude mcp --servers sequential-thinking --servers context7 --servers serena

git clone https://github.com/DataDog/experimental.git $HOME/dd/experimental
ln -s $HOME/dd/experimental/users/vishal.shah/dev $HOME/dev