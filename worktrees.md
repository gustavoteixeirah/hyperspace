Git Worktree Cheatsheet: Sibling Directory Approach

Assumed Structure:

    Main Repo: ~/code/my-project
    Worktrees: ~/code/my-project-worktrees/

1. Create Worktree for a Hotfix (from an existing branch)

You are in my-project and need to quickly work on the main branch.
```Bash

# (Optional) Create the worktrees directory if it doesn't exist
mkdir -p ~/code/my-project-worktrees

# From inside the main repo, add a worktree for the hotfix
cd ~/code/my-project
git worktree add ../my-project-worktrees/hotfix-login main

# Now, go to the new directory to start working
cd ../my-project-worktrees/hotfix-login
```

2. Create Worktree for a New Feature (create a new branch)

Start a new feature branch from develop without leaving your current branch.
```Bash

cd ~/code/my-project

# The -b flag creates a new branch named 'feature/new-api' from 'develop'
git worktree add -b feature/new-api ../my-project-worktrees/feature-new-api develop
```

3. Create Worktree for a PR Review

Review a pull request (e.g., PR #123) without stashing your work.
```Bash

cd ~/code/my-project

# Fetch the PR's code into a new local branch named 'pr-123'
git fetch origin pull/123/head:pr-123

# Create a worktree from that new local branch
git worktree add ../my-project-worktrees/review-pr-123 pr-123
```

4. List All Active Worktrees

See a map of all your project's working directories.
```Bash

cd ~/code/my-project
git worktree list
```

5. Clean Up & Remove a Worktree

Once the hotfix is merged or the PR review is done.
```Bash

# IMPORTANT: Be in any directory EXCEPT the one you are removing
cd ~/code/my-project

# Remove the worktree directory
git worktree remove ../my-project-worktrees/review-pr-123

# (Optional) Delete the temporary branch you created for the review
git branch -d pr-123
```

Note: Use `git worktree remove --force` if the worktree has uncommitted changes you want to discard.

6. Prune Dangling Worktrees

If you ever manually delete a worktree folder (rm -rf), run this to clean up Git's internal references.
```Bash

cd ~/code/my-project
git worktree prune
```

