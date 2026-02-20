---
name: model-router
description: Route tasks to the most suitable model by difficulty, latency, and cost. Use when user asks to choose a model automatically, split work by task complexity, or run different models for translation/summarization/analysis/coding.
---

# Model Router

Route each task to a model with predictable rules.

## Model Map

- `codex`: coding, debugging, implementation planning, tool-heavy execution.
- `deepseek-v3.2`: general chat, translation, rewrite, routine extraction.
- `kimi`: medium-complexity Chinese writing, long-context synthesis, stable fallback.
- `deepseek-r1`: hard reasoning, strategy tradeoffs, multi-step inference.

## Routing Rules

1. Classify task as `light`, `medium`, or `heavy`.
2. Pick primary model by class:
   - `light` -> `deepseek-v3.2` (fallback `kimi`)
   - `medium` -> `kimi` (fallback `deepseek-v3.2`)
   - `heavy` -> `codex` (reasoning-heavy fallback `deepseek-r1`)
3. If task is explicitly translation-first, force `deepseek-v3.2`.
4. If task is explicitly code-first, force `codex`.
5. Failure handling:
   - Single request failure (timeout/404/5xx): retry immediately with next fallback.
   - 2-3 consecutive failures on same primary: demote session to `kimi` until health recovers.
   - 3 consecutive health-check passes: promote back to original primary.
6. Always report when failover or recovery happened.

## Execution Pattern

- Default failover chain: `codex` -> `deepseek-v3.2` -> `kimi` -> `deepseek-r1`.
- For isolated heavy tasks, use subagent execution with explicit model.
- For scheduled jobs, set `payload.model` to the routed model.
- Keep outputs concise and include final model used and whether fallback was used.

## Output Footer

Append one line at the end:

`Model used: <alias>`
