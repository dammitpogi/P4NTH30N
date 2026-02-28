> ## Documentation Index
> Fetch the complete documentation index at: https://docs.windsurf.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Workflows

> Create reusable Cascade workflows as markdown files to automate repetitive tasks like deployments, PR reviews, and code formatting with slash commands.

Workflows enable users to define a series of steps to guide Cascade through a repetitive set of tasks, such as deploying a service or responding to PR comments.

These Workflows are saved as markdown files, allowing users and their teams an easy repeatable way to run key processes.

Once saved, Workflows can be invoked in Cascade via a slash command with the format of `/[name-of-workflow]`

## How it works

Rules generally provide large language models with guidance by providing persistent, reusable context at the prompt level.

Workflows extend this concept by providing a structured sequence of steps or prompts at the trajectory level, guiding the model through a series of interconnected tasks or actions.

<Frame>
  <img style={{ maxHeight: "400px" }} src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/use-workflow-pr.png?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=753d27e7c9e49d1feca84a2b8272f8e6" data-og-width="718" width="718" data-og-height="510" height="510" data-path="assets/windsurf/cascade/use-workflow-pr.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/use-workflow-pr.png?w=280&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=b8f833514a2b7a1bad49bfaf84e47f8a 280w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/use-workflow-pr.png?w=560&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=400b2a092b1e34276e0281085a106e1c 560w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/use-workflow-pr.png?w=840&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=9d2098efff896dea137777fb7876f23b 840w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/use-workflow-pr.png?w=1100&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=582ff2b958ad653f19c8c31d7ed2af58 1100w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/use-workflow-pr.png?w=1650&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=ecbde9bac2a87f74beba39b1542f079e 1650w, https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/use-workflow-pr.png?w=2500&fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=0b22373ae141547fbe493d1314acfcfa 2500w" />
</Frame>

To execute a Workflow, users simply invoke it in Cascade using the `/[workflow-name]` command.

<Tip>You can call other Workflows from within a Workflow! <br /><br />For example, /workflow-1 can include instructions like "Call /workflow-2" and "Call /workflow-3".</Tip>

Upon invocation, Cascade sequentially processes each step defined in the Workflow, performing actions or generating responses as specified.

## How to create a Workflow

To get started with Workflows, click on the `Customizations` icon in the top right slider menu in Cascade, then navigate to the `Workflows` panel. Here, you can click on the `+ Workflow` button to create a new Workflow.

Workflows are saved as markdown files within `.windsurf/workflows/` directories and contain a title, description, and a series of steps with specific instructions for Cascade to follow.

## Workflow Discovery

Windsurf automatically discovers workflows from multiple locations to provide flexible organization:

* **Current workspace and sub-directories**: All `.windsurf/workflows/` directories within your current workspace and its sub-directories
* **Git repository structure**: For git repositories, Windsurf also searches up to the git root directory to find workflows in parent directories
* **Multiple workspace support**: When multiple folders are open in the same workspace, workflows are deduplicated and displayed with the shortest relative path

### Workflow Storage Locations

Workflows can be stored in any of these locations:

* `.windsurf/workflows/` in your current workspace directory
* `.windsurf/workflows/` in any sub-directory of your workspace
* `.windsurf/workflows/` in parent directories up to the git root (for git repositories)

When you create a new workflow, it will be saved in the `.windsurf/workflows/` directory of your current workspace, not necessarily at the git root.

Workflow files are limited to 12000 characters each.

<video autoPlay controls muted loop playsInline className="w-full aspect-video" src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/create-workflow.mp4?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=d79db41f1ecd46f1fcdf07476bf2aaf1" data-path="assets/windsurf/cascade/create-workflow.mp4" />

### Generate a Workflow with Cascade

You can also ask Cascade to generate Workflows for you! This works particularly well for Workflows involving a series of steps in a particular CLI tool.

<video autoPlay controls muted loop playsInline className="w-full aspect-video" src="https://mintcdn.com/codeium/qJj_RRojefb93yIg/assets/windsurf/cascade/create-workflow-with-cascade.mp4?fit=max&auto=format&n=qJj_RRojefb93yIg&q=85&s=f4d4dc32f319a356a776e03d355907a5" data-path="assets/windsurf/cascade/create-workflow-with-cascade.mp4" />

## Example Workflows

There are a myriad of use cases for Workflows, such as:

<Card title="/address-pr-comments">
  This is a Workflow our team uses internally to address PR comments:

  ```
  1. Check out the PR branch: `gh pr checkout [id]`

  2. Get comments on PR

   bash
   gh api --paginate repos/[owner]/[repo]/pulls/[id]/comments | jq '.[] | {user: .user.login, body, path, line, original_line, created_at, in_reply_to_id, pull_request_review_id, commit_id}'

  3. For EACH comment, do the following. Remember to address one comment at a time.
   a. Print out the following: "(index). From [user] on [file]:[lines] — [body]"
   b. Analyze the file and the line range.
   c. If you don't understand the comment, do not make a change. Just ask me for clarification, or to implement it myself.
   d. If you think you can make the change, make the change BEFORE moving onto the next comment.

  4. After all comments are processed, summarize what you did, and which comments need the USER's attention.
  ```
</Card>

<Card title="/git-workflows">
  Commit using predefined formats and create a pull requests with standardized title and descriptions using the appropriate CLI commands.
</Card>

<Card title="/dependency-management">
  Automate the installation or updating of project dependencies based on a configuration file (e.g., requirements.txt, package.json).
</Card>

<Card title="/code-formatting">
  Automatically run code formatters (like Prettier, Black) and linters (like ESLint, Flake8) on file save or before committing to maintain code style and catch errors early.
</Card>

<Card title="/run-tests-and-fix">
  Run or add unit or end-to-end tests and fix the errors automatically to ensure code quality before committing, merging, or deploying.
</Card>

<Card title="/deployment">
  Automate the steps to deploy your application to various environments (development, staging, production), including any necessary pre-deployment checks or post-deployment verifications.
</Card>

<Card title="/security-scan">
  Integrate and trigger security vulnerability scans on your codebase as part of the CI/CD pipeline or on demand.
</Card>

## System-Level Workflows (Enterprise)

Enterprise organizations can deploy system-level workflows that are available globally across all workspaces and cannot be modified by end users without administrator permissions. This is ideal for enforcing organization-wide development processes, deployment procedures, and compliance workflows.

System-level workflows are loaded from OS-specific directories:

**macOS:**

```
/Library/Application Support/Windsurf/workflows/*.md
```

**Linux/WSL:**

```
/etc/windsurf/workflows/*.md
```

**Windows:**

```
C:\ProgramData\Windsurf\workflows\*.md
```

Place your workflow files (as `.md` files) in the appropriate directory for your operating system. The system will automatically load all `.md` files from these directories.

### Workflow Precedence

When workflows with the same name exist at multiple levels, system-level workflows take the highest precedence:

1. **System** (highest priority) - Organization-wide workflows deployed by IT
2. **Workspace** - Project-specific workflows in `.windsurf/workflows/`
3. **Global** - User-defined workflows
4. **Built-in** - Default workflows provided by Windsurf

This means that if an organization deploys a system-level workflow with a specific name, it will override any workspace, global, or built-in workflow with the same name.

In the Cascade UI, system-level workflows are displayed with a "System" label and cannot be deleted by end users.

<Note>
  **Important**: System-level workflows should be managed by your IT or security team. Ensure your internal teams handle deployment, updates, and compliance according to your organization's policies. You can use standard tools and workflows such as Mobile Device Management (MDM) or Configuration Management to do so.
</Note>
