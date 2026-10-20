# Squad

A ready-made team of Claude sub-agents. A **squad-leader** reads your task, picks the members it needs from the roster, assigns the work and signs off on the result.

| Agent | Model | Role |
|---|---|---|
| `squad-leader` | opus | Plans, recruits, dispatches, approves |
| `architect` | opus | System and solution design |
| `reviewer` | opus | Independent review of the final result |
| `security` | opus | Defensive security review |
| `engineer` | sonnet | Backend / general code |
| `frontend` | sonnet | UI, components, accessibility |
| `tester` | sonnet | Reproduces bugs, writes and runs tests |
| `devops` | sonnet | Builds, CI/CD, infra, deploys |
| `researcher` | sonnet | Current docs, options, prior art |
| `scout` | haiku | Read-only codebase mapping |
| `scribe` | haiku | Docs, changelogs, summaries |

The full roster, personas and rules live in [`SQUAD.md`](SQUAD.md). Each agent's runnable definition is in [`.claude/agents/`](.claude/agents/).

---

## Instructions for Claude

If a user asks you to "build a team", "set up the squad" or similar from this repository, do the following in **their** project:

1. Copy every file in `.claude/agents/` from this repo into the project's `.claude/agents/` folder. Don't overwrite files that already exist there — tell the user which ones you skipped.
2. Copy `SQUAD.md` into the project root (skip if one exists).
3. Tell the user the squad is installed and how to start it (see *Running the squad* below).
4. If the user also gave you a task, act as `squad-leader`: read `SQUAD.md`, write a Squad Plan, and dispatch the members.

---

## Install

**Ask Claude** (inside Claude Code, in your project):

```
Build a team from github.com/oorbt/squad
```

**Or run the script:**

```bash
# into the current project
curl -fsSL https://raw.githubusercontent.com/oorbt/squad/main/install.sh | bash

# into every project on this machine
curl -fsSL https://raw.githubusercontent.com/oorbt/squad/main/install.sh | bash -s -- --global
```

**Or copy by hand:** put `.claude/agents/*.md` in your project's `.claude/agents/` and `SQUAD.md` in the project root.

---

## Running the squad

Sub-agents can't spawn other sub-agents, so the leader needs to be the **main session**:

```bash
claude --agent squad-leader
```

Then give it a task:

```
Add password reset by email to the API, with tests.
```

The leader will size the task, post a Squad Plan, and dispatch members in parallel where it can.

Alternatively, in a normal session just say *"Act as squad-leader from SQUAD.md and …"*.

---

## Customising

- **Change a model:** edit the `model:` line in that agent's file (`opus`, `sonnet`, `haiku`, or `inherit`).
- **Restrict tools:** edit the `tools:` line. Remove it to give the agent every tool.
- **Add a member:** copy an agent file, change the frontmatter and prompt, then add it to the tables in `SQUAD.md` §2 and §5.
