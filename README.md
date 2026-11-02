# Humanizer for agents

This repository packages the original Humanizer skill for agents that support the Agent Skills format, plus host-specific manifests and uploadable ZIP files. The skill itself is one canonical `SKILL.md`, from [blader/humanizer](https://github.com/blader/humanizer).

## Install

### Agent Skills CLI

Install it for every agent supported by the Skills CLI:

```bash
npx skills add gamechanged129/humanizer-chatgpt-plugin --global --agent '*'
```

For the current project only, leave out `--global`. The CLI's agent list can change; this installs to the agents supported by the version you run.

### Claude Code plugin

```text
/plugin marketplace add gamechanged129/humanizer-chatgpt-plugin
/plugin install humanizer@humanizer-community
```

### ChatGPT plugin upload

Upload [`dist/Humanizer-plugin.zip`](dist/Humanizer-plugin.zip) in ChatGPT where plugin upload is available.

### Skill ZIP upload

For products that accept an uploaded skill archive, use [`dist/Humanizer-skill.zip`](dist/Humanizer-skill.zip).

### Other agents

If your agent supports Agent Skills but is not listed by the CLI, place the root `SKILL.md` in that agent's skill directory. For an agent without skill loading, copy the skill instructions into its system instructions or a reusable prompt. Unsupported agents cannot load a plugin automatically.

## What's included

- `SKILL.md`: canonical, agent-neutral Humanizer instructions.
- `.claude-plugin/` and `.cursor-plugin/`: Claude Code and Cursor plugin manifests.
- `agents/openai.yaml`: OpenAI-compatible UI metadata.
- `plugin.json`: ChatGPT plugin manifest used to build the upload ZIP.
- `scripts/build_packages.ps1`: rebuilds the ChatGPT plugin and skill ZIPs from the canonical skill.

## Build the ZIP files

```powershell
pwsh -File scripts/build_packages.ps1
```

## Attribution and license

The Humanizer instructions originate from [blader/humanizer](https://github.com/blader/humanizer), by Siqi Chen, and are licensed under MIT. The original copyright and license are preserved in `LICENSE` and in the bundled skill. This repository is an independent community packaging project, not the upstream project.
