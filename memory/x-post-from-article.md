---
name: x-post-from-article
description: How to summarize a given article into an X (Twitter) post for the user
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 8f8236a3-68d3-434a-944c-90abfaf67a0f
---

When the user gives a specific article URL and asks for an X (Twitter) post, write it as Nishika's CTO doing corporate technical outreach aimed at AI engineers.

A `/x-post` skill at `~/.claude/skills/x-post/SKILL.md` automates this exact procedure; prefer it when the user invokes `/x-post`.

**Why:** This is a recurring task; the user is the CTO of Nishika and posts company tech-blog articles to X.

**How to apply:**
- Tone: calm, professional corporate voice. No emoji, no excessive exclamation marks, no hashtags by default.
- Japanese; use standard engineer-facing terminology.
- Structure: line 1 = `Nishika技術ブログを更新しました。`; body = 1-2 sentences leading with the most non-obvious/interesting insight plus concrete numbers (data scale, scores); end with the article URL.
- Must fit X's 280 limit (full-width char = 2, half-width = 1, URL counts as 23). Target ~270 for margin. If over, compress while keeping numbers, key architecture, and the non-obvious finding.
- Output: post in a code block + approx X-weighted char count + bullet list of trims/edits made.
