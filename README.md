# Agent Skills

A collection of AI agent skills for use with GitHub Copilot, Claude, and other LLM-powered coding assistants.

## Skills

| Skill | Description |
|-------|-------------|
| [compose-icon](./compose-icon/) | Full-pipeline guide for creating Liquid Glass app icons with Apple's Icon Composer — design, export, import, tune glass, appearance review, and Xcode delivery. Includes an SVG prep script that validates and splits layers ready for import. |
| [swift-protocol-witness](./swift-protocol-witness/) | Design and generate Swift protocol witness structs — struct-based alternatives to protocols using closure properties. |

## Usage

### Install with npx (recommended)

```bash
# Install a skill globally (available in all projects)
npx skills add neonindigo/agent-skills --skill <skill-name> -g

# Install into the current project only
npx skills add neonindigo/agent-skills --skill <skill-name>

# Browse all available skills before installing
npx skills add neonindigo/agent-skills --list
```

### Install manually

Copy a skill folder into your agent's skills directory:

```bash
# Project-local
cp -r <skill-name>/ .agents/skills/<skill-name>/

# Global
cp -r <skill-name>/ ~/.agents/skills/<skill-name>/
```

Each skill is self-contained with a `SKILL.md` (agent instructions) and optional supporting files.

## Adding New Skills

Create a new folder at the repo root using kebab-case naming:

```
your-skill-name/
├── SKILL.md            # Required: agent instructions
├── references/         # Optional: detailed reference docs
├── scripts/            # Optional: validation/automation scripts
└── assets/             # Optional: templates or static files
```

## License

CC-BY-4.0
