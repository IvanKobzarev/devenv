# .bash_profile

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

PATH=$PATH:$HOME/bin

shopt -s checkwinsize

export PATH
unset USERNAME

export EDITOR=vim

# Keep tmux sockets in home directory to avoid /tmp cleanup issues
export TMUX_TMPDIR="$HOME/.tmux-sockets"
mkdir -p "$TMUX_TMPDIR"

# Git branch in prompt
git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export PS1=' \w\[\033[0;32m\] $(git branch 2>/dev/null | grep "^*" | colrm 1 2)\[\033[0;32m\]\n└─\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\]\[\033[0m\] '

function cls {
  clear && printf '\e[3J'
}

export CC=gcc
export CXX=g++

# ctags for C++ projects
function ctagsup() {
  ctags -R -–python-kinds=-i --c++-kinds=+p --fields=+iaS --extra=+q --exclude=.git --exclude=build* --links=no
}

# git: stage all modified files shown by git status
function git_status_add() {
  git status -s | awk '{print $2}' | xargs git add
}

alias rg="rg --hidden --glob '!.git'"

# PyTorch JIT graph inspection
function print_graph() {
  python -c "import torch; m = torch.jit.load('$1').eval(); print(m.graph)"
}

function print_graph_opt() {
  python -c "import torch; from torch.utils.mobile_optimizer import optimize_for_mobile; from torch import nn; m = torch.jit.load('$1').eval(); m = optimize_for_mobile(m); print(m.graph)"
}

function print_graph_shape_prop() {
  python -c "import torch; from torch import nn; m = torch.jit.load('$1').eval(); inputs = list(m.graph.inputs()); size = [$2]; inputs[1].setType(inputs[1].type().with_sizes(size));torch._C._jit_pass_propagate_shapes_on_graph(m.graph);print(m.graph)"
}

# Parse pytorch training logs for throughput and memory stats
function tune_logs_tps () {
  if [ -z "$1" ]; then
    echo "No log path specified"
    return 1
  fi
  awk -F"[: |]" '{ v = $10 ; total += v } END { print "tps_avg:", total/NR, " n=", NR }' $1
  MAX_ALLOC=$(cat $1 | awk -F"[: |]" '{ print $14 }' | sort | tail -1)
  printf "peak_memory_alloc max %7.2f\n" $MAX_ALLOC
  MAX_RESERVED=$(cat $1 | awk -F"[: |]" '{ print $16 }' | sort | tail -1)
  printf "peak_memory_reser max %7.2f\n" $MAX_RESERVED
}

export TORCH_LOGS_FORMAT="%(levelname)s: %(message)s"

alias test_torch_cuda="python -c 'import torch; print(torch.cuda.is_available())'"
alias tlparser="tlparse --rank 0"

# Git fork helpers (generic -- customize FORK_USER and FORK_REPO)
FORK_USER="IvanKobzarev"

function git_fork_checkout () {
  local FORK_REPO="${1:?Usage: git_fork_checkout <fork_repo_name> [branch]}"
  local BRANCH="${2:-$(git rev-parse --abbrev-ref HEAD)}"
  git remote get-url fork 2>/dev/null || git remote add fork "https://github.com/${FORK_USER}/${FORK_REPO}.git"
  git stash
  git fetch fork "$BRANCH" && git checkout "$BRANCH" && git reset --hard "fork/$BRANCH"
  git stash pop || true
}

function git_fork_push_force () {
  local FORK_REPO="${1:?Usage: git_fork_push_force <fork_repo_name> [branch]}"
  local BRANCH="${2:-$(git rev-parse --abbrev-ref HEAD)}"
  git remote get-url fork 2>/dev/null || git remote add fork "https://github.com/${FORK_USER}/${FORK_REPO}.git"
  git push --force fork "$BRANCH"
}

# Download full raw CI logs for failed jobs in a GitHub PR
# Usage: gh_pr_logs <pr_number> [output_dir]
gh_pr_logs() {
  local repo="${1:?Usage: gh_pr_logs <owner/repo> <pr_number> [output_dir]}"
  local pr_num="${2:?Usage: gh_pr_logs <owner/repo> <pr_number> [output_dir]}"
  local output_dir="${3:-$HOME/tmp-pr${pr_num}-$(date +%Y%m%d-%H%M%S)}"

  mkdir -p "$output_dir"
  echo "Downloading failed CI logs for ${repo} PR #${pr_num} to ${output_dir}"

  local head_sha=$(gh pr view "$pr_num" --repo "$repo" --json headRefOid --jq '.headRefOid')
  echo "Head SHA: $head_sha"

  local page=1
  while true; do
    echo "Fetching check-runs page $page..."
    local check_runs=$(gh api "repos/${repo}/commits/${head_sha}/check-runs?per_page=100&page=${page}" 2>/dev/null)
    local count=$(echo "$check_runs" | jq '.check_runs | length')
    if [[ "$count" == "0" || -z "$count" ]]; then
      break
    fi
    echo "$check_runs" | jq -r '.check_runs[] | select(.conclusion == "failure" or .conclusion == "cancelled") | "\(.id)|\(.name)|\(.conclusion)"' | while IFS='|' read -r job_id job_name job_conclusion; do
      if [[ -n "$job_id" ]]; then
        local safe_name=$(echo "${job_name}" | tr ' /:(),' '______' | tr -cd '[:alnum:]_.-')
        local log_file="${output_dir}/${safe_name}_${job_id}.log"
        [[ -f "$log_file" ]] && continue
        echo "  Downloading: $job_name ($job_conclusion)..."
        gh api "repos/${repo}/actions/jobs/${job_id}/logs" > "$log_file" 2>/dev/null
        if [[ -s "$log_file" ]]; then
          echo "    Saved: $(basename "$log_file") ($(du -h "$log_file" | cut -f1))"
        else
          rm -f "$log_file"
          echo "    No logs available"
        fi
      fi
    done
    ((page++))
    [[ $page -gt 10 ]] && break
  done

  local comments_dir="${output_dir}/comments"
  mkdir -p "$comments_dir"
  echo ""
  echo "Downloading PR comments..."
  gh api "repos/${repo}/issues/${pr_num}/comments" --paginate \
    | jq -r '.[] | "--- \(.user.login) (\(.created_at)) ---\n\(.body)\n"' \
    > "${comments_dir}/pr_comments.txt" 2>/dev/null
  echo "Downloading inline review comments..."
  gh api "repos/${repo}/pulls/${pr_num}/comments" --paginate \
    | jq -r '.[] | "--- \(.user.login) (\(.created_at)) \(.path):\(.line // .original_line // "?") ---\n\(.body)\n"' \
    > "${comments_dir}/inline_comments.txt" 2>/dev/null

  echo ""
  echo "Done. Logs in: $output_dir"
  ls -lah "$output_dir" | head -30
}
