# Agent Skills

A collection of AI agent skills for use with GitHub Copilot, Claude, and other LLM-powered coding assistants.

## Skills

| Skill | Description |
|-------|-------------|
| [compose-icon](./compose-icon/) | Full-pipeline guide for creating Liquid Glass app icons with Apple's Icon Composer — design, export, import, tune glass, appearance review, and Xcode delivery. Includes an SVG prep script that validates and splits layers ready for import. |
| [swift-protocol-witness](./swift-protocol-witness/) | Design and generate Swift protocol witness structs — struct-based alternatives to protocols using closure properties. |

## Usage

Copy a skill folder into your agent's skills directory:

```bash
# Example: install into your project
cp -r swift-protocol-witness/ .agents/skills/swift-protocol-witness/

# Or into your global skills directory
cp -r swift-protocol-witness/ ~/.agents/skills/swift-protocol-witness/
```

Each skill is self-contained with a `SKILL.md` (agent instructions) and optional `references/` for supporting material.

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
