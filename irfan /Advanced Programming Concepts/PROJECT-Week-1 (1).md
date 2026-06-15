# CSC 6302 Advanced Programming Concepts — Week 1
## Git Version Control Tutorial

This tutorial walks you through every Git command covered in the Week 1 slides.
You will complete two tracks:

- **Track A** — Create a brand-new local repository, connect it to a remote on GitLab, and push your work.
- **Track B** — Clone an existing repository that your instructor has already set up for you on GitLab.

Work through Track A first. Track B is independent and can be done in any order.

Note that all commit hashes you see here are examples and will be different in your own git history.

---

## Operating System Requirements

All commands in this tutorial are written for a **Unix-style shell** (bash or zsh).

| Platform | Supported environment |
|---|---|
| **Linux** | Any terminal — all commands work as written |
| **Mac** | Terminal (zsh) or iTerm2 — all commands work as written |
| **Windows** | **WSL-2 only** — open your WSL-2 terminal and run everything from there |

> **Windows users: native Windows (Command Prompt, PowerShell, or Git Bash)
> is not a supported environment for this tutorial.** You must use WSL-2.
> If WSL-2 is not installed, follow the
> [Microsoft WSL installation guide](https://learn.microsoft.com/en-us/windows/wsl/install)
> before continuing. Once inside a WSL-2 terminal, every command in both
> tracks runs exactly as written.

Where a specific command behaves differently on Mac it is noted inline.

---

## Prerequisites

Before you begin, make sure Git is installed and configured with your identity.
These settings are stored globally and appear in every commit you make.

```bash
git config --global user.name "Your Name"
git config --global user.email "your@merrimack.edu"
```

Verify the settings were saved:

```bash
git config --global --list
```

---

## Track A — Create a local repo and connect it to GitLab

### Step 1 — Create a new local directory and initialize Git

Create a folder for your project anywhere on your machine, then initialize a
Git repository inside it.

```bash
mkdir csc6304-week1
cd csc6304-week1
git init
```

`git init` creates a hidden `.git/` folder — the repository database that will
store every snapshot you commit. Your working directory is now tracked by Git,
but nothing has been committed yet.

Verify:

```bash
git status
```

You should see:

```
On branch main
No commits yet
nothing to commit (create/copy files and work to commit)
```

> **Note:** If your default branch is called `master` instead of `main`, you
> can rename it:
> ```bash
> git branch -m master main
> ```

---

### Step 2 — Create two empty files and check status

Create two empty files: `notes.md` and `ideas.md`. Starting them empty keeps
this step simple — you will add content in a later step.

```bash
touch notes.md
touch ideas.md
```

> **Mac users:** `touch` works identically in macOS Terminal — no changes needed.
>
> **Windows users:** `touch` is a Linux command. This is why you must be in a
> WSL-2 terminal. Running this inside WSL-2 works exactly as shown above.

Run `git status` to see how Git sees them:

```bash
git status
```

Both files appear under **Untracked files** — Git sees them but is not yet
tracking either one.

```
Untracked files:
  (use "git add <file>..." to include in what will be committed)
        ideas.md
        notes.md
```

---

### Step 3 — Stage both files and make the root commit

Stage both files and commit them. This is the **root commit** — it has no
parent. In Git lore, every repository has to start somewhere with a commit
that came from nothing. We use the message `"Batman"` as a reminder of that:
just like Batman's origin story, this first commit has no parents.

```bash
git add notes.md ideas.md
git commit -m "Batman"
```

Confirm the commit was recorded:

```bash
git log --oneline
```

```
a1b2c3d Batman (Note that your hash will most likely be different)
```

This snapshot is now Git's baseline. Every `git diff` from this point forward
compares against what was committed here — two empty files.

---

### Step 4 — Add content to both files, stage only one

Now open each file in your text editor and add some content.

Add the following to `notes.md`:

```
# Week 1 Notes

## Lecture 1
- Version control tracks changes to files over time
- Git is distributed: every developer has a full copy
```

Add the following to `ideas.md`:

```
# Ideas

## Project ideas
- Build a CLI tool in Python
```

Save both files. Now **stage only `notes.md`** — leave `ideas.md` unstaged:

```bash
git add notes.md
```

Run `git status` to see all three states at once:

```bash
git status
```

```
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        modified:   notes.md

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
        modified:   ideas.md
```

- `notes.md` is **staged** (green) — queued for the next commit.
- `ideas.md` is **modified but unstaged** (red) — edited in your working
  directory but not yet queued for the commit.

---

### Step 5 — Inspect changes with `git diff` and `git diff --staged`

With the two files deliberately in different states, each diff command shows
something different and neither returns empty output.

#### `git diff` — unstaged changes only

```bash
git diff
```

This compares your **working directory** against the **staging area**. Because
`notes.md` is already staged, only the unstaged edit to `ideas.md` appears:

```diff
diff --git a/ideas.md b/ideas.md
index e69de29..b6fc4c6 100644
--- a/ideas.md
+++ b/ideas.md
@@ -0,0 +1,5 @@
+# Ideas
+
+## Project ideas
+- Build a CLI tool in Python
```

Lines beginning with `+` are additions; lines with `-` are removals.
The index `e69de29` is Git's hash for an empty file — confirming our Batman
commit contained empty files.

#### `git diff --staged` — staged changes only

```bash
git diff --staged
```

This compares the **staging area** against the **last commit** (Batman). Only
the staged edit to `notes.md` appears:

```diff
diff --git a/notes.md b/notes.md
index e69de29..4b3a8f1 100644
--- a/notes.md
+++ b/notes.md
@@ -0,0 +1,6 @@
+# Week 1 Notes
+
+## Lecture 1
+- Version control tracks changes to files over time
+- Git is distributed: every developer has a full copy
```

> **Tip:** Always run `git diff --staged` before committing. It shows you
> exactly what will be saved in the next snapshot — no surprises.

---

### Step 6 — Commit the staged file, then stage and commit the second

Commit only the staged `notes.md` first:

```bash
git commit -m "Add lecture 1 notes"
```

`ideas.md` is still sitting as an unstaged modification. Stage and commit it
separately to practice targeting individual files:

```bash
git status           # confirms ideas.md is still modified/unstaged
git diff             # shows the ideas.md changes one last time
git add ideas.md
git diff --staged    # confirms the ideas.md changes are now queued
git commit -m "Add initial project ideas"
```

View the full history so far:

```bash
git log --oneline
```

```
c3d4e5f Add initial project ideas
b2c3d4e Add lecture 1 notes
a1b2c3d Batman
```

You now have three commits. The root `Batman` commit gave both diffs a real
baseline to measure against, and the two files in different states let you
see `git diff` and `git diff --staged` each reporting something distinct.

---

### Step 7 — Create a remote repository on GitLab

1. Log in to the Merrimack GitLab instance provided by your instructor.
2. Click **New project** → **Create blank project**.
3. Name it `week-1-a`.
4. Set the visibility to **Private**.
5. **Uncheck** "Initialize repository with a README" — your local repo already
   has commits; starting the remote empty avoids a merge conflict.
6. Click **Create project**.

GitLab will show you the repository URL. Copy the HTTPS URL — it looks like:

```
https://gitlab.com/csc6304/{yourusername}/week-1-a.git

```

---

### Step 8 — Connect the remote with `git remote add`

Back in your terminal, link your local repository to the GitLab remote you
just created. The conventional name for the primary remote is `origin`.

```bash
git remote add origin https://gitlab.com/csc6304/{yourusername}/week-1-a.git

```

Verify the remote was registered:

```bash
git remote -v
```

```
origin  https://gitlab.com/csc6304/{yourusername}/week-1-a.git (fetch)
origin  https://gitlab.com/csc6304/{yourusername}/week-1-a.git (push)
```

---

### Step 9 — Push your commits to GitLab

Send your local commits up to the remote repository. The `-u` flag sets
`origin main` as the default upstream, so future pushes only need `git push`.

```bash
git push -u origin main
```

Git will prompt for your GitLab username and password (or personal access
token if your instance requires one). After a successful push, refresh the
GitLab project page in your browser — you should see `notes.md` there.

> **GitLab's "Push an existing repository" panel**
>
> When you create a blank project, GitLab displays a panel with four commands
> for connecting an existing repo. You will see these in the GitLab UI:
>
> ```bash
> git remote rename origin old-origin
> git remote add origin https://gitlab.com/csc6304/…/week-1-a.git
> git push --set-upstream origin --all
> git push --set-upstream origin --tags
> ```
>
> Here is how those four lines relate to what you just did:
>
> | GitLab command | What it does | This tutorial |
> |---|---|---|
> | `git remote rename origin old-origin` | Renames any existing `origin` remote to avoid a name collision | **Skip** — you ran `git init` from scratch, so there is no `origin` to rename. Running it will produce a harmless error. |
> | `git remote add origin <url>` | Adds the GitLab remote | Done in **Step 8** |
> | `git push --set-upstream origin --all` | Pushes **all** local branches and sets the upstream tracking reference | Equivalent to `git push -u origin main` from above — use this form if you have multiple branches to push at once |
> | `git push --set-upstream origin --tags` | Pushes all local tags to the remote | No tags exist yet, but run it anyway to stay in sync with what GitLab expects |
>
> If you prefer to follow GitLab's exact sequence, skip the first line and run
> the remaining three instead of the single `git push -u origin main` above —
> the end result is identical for a repo with one branch and no tags.

---

### Step 10 — Create a feature branch

Branches let you work on something new without touching the stable `main`
branch. Create and switch to a branch in one command:

```bash
git checkout -b feature-add-readme
```

The modern equivalent (Git 2.23+):

```bash
git switch -c feature-add-readme
```

List all branches to confirm you are on the new one (the `*` marks the
current branch):

```bash
git branch
```

```
* feature-add-readme
  main
```

---

### Step 11 — Work on the branch and commit

Create a `README.md` file for your project on this branch:

```bash
echo "# CSC 6304 Week 1 Project" > README.md
git add README.md
git commit -m "Add README for week 1 project"
```

Make another small edit to `notes.md`, stage it, and commit:

```bash
# edit notes.md in your editor, then:
git add notes.md
git commit -m "Expand notes with lecture examples"
```

View the branch's history:

```bash
git log --oneline
```

---

### Step 12 — Merge the branch into main locally and push to origin

Switch back to `main`, then bring in the commits from your feature branch:

```bash
git checkout main
git merge feature-add-readme
```

If there are no conflicting changes, Git performs a **fast-forward merge** and
`main` now contains all the commits from `feature-add-readme`.

View the log to confirm the merge landed:

```bash
git log --oneline --graph
```

```
* e4f5a6b Add README for week 1 project
* d3e4f5a Expand notes with lecture examples
* c3d4e5f Add initial project ideas
* b2c3d4e Add lecture 1 notes
* a1b2c3d Batman
```

Now push `main` to GitLab so the remote reflects the merged state:

```bash
git push origin main
```

You can optionally delete the feature branch now that its work is in `main`:

```bash
# delete locally
git branch -d feature-add-readme
```

---

### Step 13 — Stash uncommitted work temporarily

Sometimes you need to switch branches before your work is ready to commit.
`git stash` saves your in-progress changes and cleans the working directory.

Make an edit to `notes.md` (do **not** commit it), then stash it:

```bash
# edit notes.md in your editor (don't stage or commit), then:
git stash
```

Check that the working directory is clean:

```bash
git status
```

See the list of saved stashes:

```bash
git stash list
```

```
stash@{0}: WIP on main: a1b2c3d Add week 1 notes file
```

Restore your work when you are ready to continue:

```bash
git stash pop
```

`pop` applies the most recent stash **and** removes it from the list.
Use `git stash apply stash@{0}` if you want to apply a stash but keep it.

---

### Step 14 — Undo mistakes

Your history on `main` currently looks like this:

```
e4f5a6b Add README for week 1 project
d3e4f5a Expand notes with lecture examples
c3d4e5f Add initial project ideas
b2c3d4e Add lecture 1 notes
a1b2c3d Batman
```

Each exercise below targets only the specific commit or change described.
None of them will touch any other commit in the list.

---

#### 14.a — Discard working directory changes with `git restore`

Open `notes.md` in your editor and add this line at the bottom, then save:

```
MISTAKE: this line should not be here
```

Do **not** stage it. Verify it shows as an unstaged change:

```bash
git status
```

```
Changes not staged for commit:
        modified:   notes.md
```

Now discard the change — `git restore` resets the file back to its last
committed state:

```bash
git restore notes.md
```

Confirm the line is gone:

```bash
git status
cat notes.md
```

The file is back to exactly what was committed. No commit history was changed.

---

#### 14.b — Unstage a file with `git restore --staged`

Open `notes.md` again and add this line at the bottom, then save:

```
DRAFT: not ready to commit yet
```

This time, stage it:

```bash
git add notes.md
git status
```

```
Changes to be committed:
        modified:   notes.md
```

You decide it is not ready. Remove it from the staging area without losing
the edit in your working directory:

```bash
git restore --staged notes.md
```

Check the result:

```bash
git status
```

```
Changes not staged for commit:
        modified:   notes.md
```

The file still contains your draft line — it just moved back out of the
staging area. You can keep editing it or discard it with `git restore notes.md`.
No commit history was changed.

---

#### 14.c — Undo a commit safely with `git revert`

First, create a dedicated commit to revert so your existing history stays
untouched. Add a bad line to `notes.md`, stage it, and commit it:

```bash
# open notes.md and add this line at the bottom, then save:
# OOPS: committed by mistake

git add notes.md
git commit -m "Oops commit to be reverted"
```

Your log now looks like:

```
f5a6b7c Oops commit to be reverted
e4f5a6b Add README for week 1 project
d3e4f5a Expand notes with lecture examples
c3d4e5f Add initial project ideas
b2c3d4e Add lecture 1 notes
a1b2c3d Batman
```

Now revert only that top commit. Copy its hash from your own log output:

```bash
git log --oneline
git revert f5a6b7c
```

Git opens your editor for the revert commit message — save and close it to
accept the default. Your log now looks like:

```
g6b7c8d Revert "Oops commit to be reverted"
f5a6b7c Oops commit to be reverted
e4f5a6b Add README for week 1 project
d3e4f5a Expand notes with lecture examples
c3d4e5f Add initial project ideas
b2c3d4e Add lecture 1 notes
a1b2c3d Batman
```

All five original commits are completely untouched. `git revert` added a new
commit on top rather than rewriting anything. Open `notes.md` and confirm the
`OOPS` line is gone.

---

#### 14.d — Undo the revert commit with `git reset --soft`

You just created two commits (`f5a6b7c` and its revert `g6b7c8d`) that you no
longer want in the history at all. Use a soft reset to remove only the revert
commit from history while keeping the change staged so you can inspect it:

```bash
git reset --soft HEAD~1
```

Your log is now back to:

```
f5a6b7c Oops commit to be reverted
e4f5a6b Add README for week 1 project
...
```

The revert commit is gone but `notes.md` changes are still staged. Now remove
the oops commit too:

```bash
git reset --soft HEAD~1
```

Check status — the `OOPS` line is staged but not committed:

```bash
git status
```

Finally, discard that staged change entirely:

```bash
git restore --staged notes.md
git restore notes.md
```

Your log is now exactly what it was at the start of step 14:

```bash
git log --oneline
```

```
e4f5a6b Add README for week 1 project
d3e4f5a Expand notes with lecture examples
c3d4e5f Add initial project ideas
b2c3d4e Add lecture 1 notes
a1b2c3d Batman
```

> **Warning:** `git reset` rewrites history. Because these two commits were
> never pushed to the remote it is safe here. Never use `git reset` on commits
> you have already pushed — use `git revert` instead.

---

## Track B — Clone the instructor's container repository and run it as a Podman pod

Your instructor has created a repository on GitLab that contains a small
Flask web application. You will clone it, inspect the files, start it with
`podman-compose`, and watch it automatically create a data file as you use it.

The repository contains:

```
containers/
├── app.py            # Flask app — logs every visitor name to a Markdown file
├── Dockerfile        # builds the Python/Flask image
├── requirements.txt  # Python dependencies (flask)
└── compose.yaml      # starts all services inside a Podman pod
```

---

### Step 1 — Clone the repository

Use the URL provided by your instructor. The command below is a placeholder —
replace it with the real URL shown in class.

```bash
git clone https://gitlab.merrimack.edu/instructor/csc6304-containers.git
```

This downloads the full repository — all files and commit history — into a
new folder on your machine. Move into it:

```bash
cd csc6304-containers
```

---

### Step 2 — Explore the repository

Check the branch, remotes, and commit history exactly as you did in Track A:

```bash
git status
git branch
git remote -v
git log --oneline
```

Git automatically configured `origin` pointing back to the instructor's URL.
Have a look at the four files before running anything:

```bash
cat compose.yaml
cat Dockerfile
cat requirements.txt
cat app.py
```

Notice the `x-podman` block at the top of `compose.yaml`:

```yaml
x-podman:
  in_pod: true
  pod_name: week1
```

This is the instruction that tells `podman-compose` to create a **pod** named
`week1` and place every service container inside it. All containers in the
same pod share a single network namespace — they reach each other on
`localhost` without any extra networking configuration.

---

### Step 3 — Create your branch before running anything

All work — including the files the running application generates — will live
on your branch until you deliberately merge it into `main`. Create and switch
to your branch now, before the pod starts:

```bash
git checkout -b yourname-week1-containers
```

Confirm you are on the new branch:

```bash
git branch
```

```
* yourname-week1-containers
  main
```

---

### Step 4 — Start the application with podman-compose

Make sure `podman` and `podman-compose` are installed:

```bash
podman --version
podman-compose --version
```

> **Mac users:** If you are using Podman Desktop you may need to start the
> Podman machine first:
> ```bash
> podman machine start
> ```

Start the application in detached mode (runs in the background):

```bash
podman-compose up -d
```

You will see Podman build the Flask image from the `Dockerfile`, create the
pod, and start the container inside it. The output looks similar to:

```
podman build -t week1_flask .
podman pod create --name week1 --share net ...
podman run -d --pod week1 --name flask_app ...
```

---

### Step 5 — Verify the pod is running

Check that the pod exists and its containers are healthy:

```bash
podman pod ps
```

```
POD ID        NAME    STATUS    CREATED        # OF CONTAINERS
a1b2c3d4e5f6  week1   Running   5 seconds ago  2
```

The pod shows **2 containers** — the application container (`flask_app`) plus
the invisible infra/pause container that holds the shared network namespace.

Inspect the running containers inside the pod:

```bash
podman ps --pod
```

```
CONTAINER ID  IMAGE                  COMMAND        STATUS  PORTS                   NAMES      POD NAME
...           localhost/week1_flask  python app.py  Up      0.0.0.0:5000->5000/tcp  flask_app  week1
```

For a full JSON description of the pod — network settings, container IDs, and
port mappings — run:

```bash
podman pod inspect week1
```

---

### Step 6 — Use the application and watch the data file appear

Open a browser and visit:

```
http://localhost:5000
```

You should see: **Hello, World!**

Now pass your own name and a few other classmate names as query parameters:

```
http://localhost:5000/?name=Alice
http://localhost:5000/?name=Bob
```

The application writes every visit to `/data/names.md` inside the container,
which is bind-mounted to a `data/` folder in your cloned directory. Check that
the folder and file were created automatically:

```bash
ls data/
cat data/names.md
```

The file is a Markdown table that grows with every request:

```
# Name Log

| # | Name  | Timestamp               |
|---|-------|-------------------------|
| 1 | World | 2026-03-13 14:00:01 UTC |
| 2 | Alice | 2026-03-13 14:00:15 UTC |
| 3 | Bob   | 2026-03-13 14:00:22 UTC |
```

This is the volume in action — `data/` on your host is mounted into the
container at `/data`, so the file persists even if the container restarts.

View the application logs to see the requests recorded by Flask:

```bash
podman logs flask_app
```

---

### Step 7 — Commit the generated data file on your branch

The `data/names.md` file now exists on disk because you ran the pod while on
your branch. Stage it along with a short `notes.md` observation and commit
both — this records your work on the branch, not on `main`:

```bash
git status
```

```
On branch yourname-week1-containers
Untracked files:
        data/
        notes.md
```

Create `notes.md` in your editor and add a few observations — what the pod
structure looked like, how the volume worked, what `podman pod ps` showed.
Then stage and commit everything:

```bash
git add data/names.md notes.md
git commit -m "Add names log and observations from running the week1 pod"
```

Confirm the commit landed on your branch:

```bash
git log --oneline
```

```
b2c3d4e Add names log and observations from running the week1 pod
a1b2c3d Batman
```

---

### Step 8 — Stop the pod

```bash
podman-compose down
```

Verify the pod is gone:

```bash
podman pod ps
```

The `data/names.md` file remains on your host — the bind mount is not deleted
by `podman-compose down`. Your committed snapshot of it stays in the branch
history regardless.

---

### Step 9 — Pull any instructor updates before merging

Before promoting your branch to `main`, check whether the instructor has
pushed anything new since you cloned:

```bash
git fetch
git log --oneline origin/main   # see what arrived
```

If there are new commits on `origin/main`, merge them into your branch first
so that your branch is up to date before you merge it into `main`:

```bash
git merge origin/main
```

If there is nothing new, this is a no-op and you can move straight to the
next step.

---

### Step 10 — Merge your branch into main locally and push to origin

Switch to `main` and merge your branch in:

```bash
git checkout main
git merge yourname-week1-containers
```

If there are no conflicts, Git fast-forwards `main` to include your commits.
Confirm the history looks correct:

```bash
git log --oneline --graph
```

```
* b2c3d4e Add names log and observations from running the week1 pod
* a1b2c3d Batman
```

Push the updated `main` to GitLab:

```bash
git push origin main
```

Clean up the feature branch now that its work is in `main`:

```bash
git branch -d yourname-week1-containers
```

---

## Quick Reference

| Goal | Command |
|---|---|
| Configure identity | `git config --global user.name "Name"` |
| Initialize new repo | `git init` |
| Clone a remote repo | `git clone <url>` |
| Check working tree | `git status` |
| See unstaged changes | `git diff` |
| See staged changes | `git diff --staged` |
| Stage a file | `git add <file>` |
| Stage everything | `git add .` |
| Commit staged changes | `git commit -m "message"` |
| View commit history | `git log --oneline` |
| Add a remote | `git remote add origin <url>` |
| Verify remotes | `git remote -v` |
| Push to remote | `git push -u origin main` |
| Pull from remote | `git pull origin main` |
| Create branch | `git branch <name>` |
| Create & switch branch | `git checkout -b <name>` |
| Switch branch | `git checkout <name>` |
| List branches | `git branch` |
| Merge branch into current | `git merge <name>` |
| Stash uncommitted work | `git stash` |
| List stashes | `git stash list` |
| Restore latest stash | `git stash pop` |
| Discard working changes | `git restore <file>` |
| Unstage a file | `git restore --staged <file>` |
| Undo a commit (safe) | `git revert <hash>` |
| Move HEAD back (careful) | `git reset --hard <hash>` |

---

## Further Reading

- [Pro Git Book (free)](https://git-scm.com/book) — the definitive reference
- [Git command reference](https://git-scm.com/docs)
- [GitLab Docs — Merge Requests](https://docs.gitlab.com/ee/user/project/merge_requests/)
