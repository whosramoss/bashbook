# Security Policy

## Supported versions

Security fixes are considered for the latest code on the default branch (`main`).

## Reporting a vulnerability

If you find a security issue in bashbook, **do not open a public issue** with exploit details.

Report it privately instead:

- **GitHub:** use [Security → Report a vulnerability](../../security/advisories/new) if enabled on the repository.
- **Otherwise:** contact the maintainer through GitHub (private message or security contact listed on the repo).

Please include a short description, how to reproduce it, and what you think the impact is. You should get an acknowledgement when the report is received.

## What this project is

bashbook is a **local Bash library** (`commands.sh`) plus optional **system inspection scripts** under `system/`. It is meant to run on your own machine in a terminal—not as a network service.

There are no built-in accounts, databases, or cloud integrations in the core library.

## Security notes when using bashbook

**System scripts (`system/`)** read hardware and OS information. On Linux, some commands may use `sudo` (for example `dmidecode`). Only run them if you trust the script and your environment. On Windows, several commands call `powershell.exe`.

**Network use:** scripts such as `4_network.sh` may contact public services (for example via `curl`) to resolve a public IP. No credentials are sent by the stock scripts, but be aware of outbound requests if that matters in your environment.

**Output:** these tools print system details to the terminal (hostname, IPs, serial numbers, etc.). Avoid sharing logs in public channels if that data is sensitive.

**Your own scripts:** when you source `commands.sh` and pass user input into shell commands, quote variables (`"$var"`) and avoid `eval` on untrusted data—the same rules as any Bash project.

## In scope

- Command injection or unsafe execution paths in bashbook’s own functions or `system/` scripts
- Unexpected credential or secret handling added to the repository
- Issues where library behavior could mislead users into unsafe patterns (documented clearly if not fixable in code)

## Out of scope

- Vulnerabilities in Bash, PowerShell, or third-party tools the scripts call (`ip`, `wmic`, `curl`, etc.)
- Problems caused only by how you wrap or deploy bashbook in your own project
- General hardening of your OS; bashbook does not change system security settings

## For contributors

- Do not commit secrets (`.env`, keys, tokens, passwords).
- Prefer environment variables or runtime flags in examples—not hard-coded credentials.
- Review changes that run external commands or handle file paths and user input.

Thank you for helping keep the project safe.
