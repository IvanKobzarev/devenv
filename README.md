# devenv

My dotfiles. Mass-produced artisanal config, hand-tuned over many mass rebuilds of devservers that ate the previous ones.

## What's inside

| File | What it does | Survival rate across reinstalls |
|---|---|---|
| `.vimrc` | Vim config. Vundle, NERDTree, fzf, airline, desert colorscheme (the only correct one). | 100% -- outlived 3 laptops |
| `nvim/` | Neovim config (lazy.nvim). Same keybinds as vim because muscle memory > progress. | 90% -- treesitter breaks sometimes |
| `.tmux.conf` | tmux config. 100k history because scrollback is cheaper than notes. | 95% |
| `.bash_profile` | Prompt, aliases, pytorch helpers. The `cls` function exists because `clear` doesn't clear hard enough. | 80% -- accumulates cruft like a docker layer |
| `.gitconfig` | Git aliases. `git lg` is the only log format that matters. | 100% |
| `.inputrc` | Readline config. 3 lines that make tab-completion bearable. | 100% -- too small to break |
| `install.sh` | Symlinks everything. Backs up existing files so you can pretend you'll restore them. | N/A |

## Install

```bash
git clone https://github.com/IvanKobzarev/devenv.git ~/github/devenv
cd ~/github/devenv
chmod +x install.sh
./install.sh
```

Then open vim and run `:PluginInstall`. Neovim plugins install automatically via lazy.nvim.

## Highlights

- **Ctrl-P** -- fuzzy find files (fzf in vim, telescope in nvim)
- **Ctrl-G** -- live grep across project
- **Ctrl-L** -- switch buffers
- **F2** -- toggle between `.h` and `.cpp` (the eternal dance)
- **Space** -- fold/unfold code (because reading code is optional)
- **z1-z9** -- set fold level (z1 = "show me nothing", z9 = "show me everything")
- `cls` -- `clear` but actually clears the scrollback too
- `git lg` -- the pretty git log
- `gh_pr_logs` -- download all failed CI logs from a GitHub PR (for when the web UI times out)
- `print_graph` / `print_graph_opt` -- inspect PyTorch JIT model graphs

## Philosophy

If it takes more than 5 minutes to set up a new machine, something is wrong. If it takes less than 5 minutes, you forgot to install tmux.
