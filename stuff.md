# Claude Memory — 30-Minute Talk Runbook

**Audience:** developers / technical
**Format:** no slides — talk through ASCII visuals on screen, run live demos in the Claude app ("the prompt") and Claude Code ("the terminal")
**Split:** even — app memory and Claude Code memory get roughly equal time
**Running example:** a vanilla **Spring Boot 4.x Maven PetClinic** — owners, pets, vets, visits. All terminal demos use this repo.

> Keep this open on a second screen. Visuals are collected in the Appendix so you can paste them full-size into whatever you're sharing.
>
> **PetClinic facts to have right** (a Java audience will check): Spring Boot 4.0 shipped Nov 30 2025 on Spring Framework 7; **Java 17 baseline** (Java 25 LTS supported); **Maven** build via `./mvnw`; `jakarta.*` namespace (not `javax.*`); JUnit 5; H2 in-memory by default. These are exactly the facts the bloated CLAUDE.md gets *wrong* on purpose.

---

## Timing at a glance

| Block | Time | What happens |
|---|---|---|
| 0. Cold open | 1 min | The "blank slate" hook |
| 1. Theory | 6 min | Stateless problem, context vs memory, the three systems |
| 2. Demo A — the prompt | 7 min | App memory: synthesis, edit, projects, incognito |
| 3. Demo B — the terminal | 11 min | **Context-pollution A/B (centerpiece)** + three-tier loading model, then `/init`, `#`→auto-memory, `/memory`, hierarchy |
| 4. Best practices | 2 min | What belongs in memory, what doesn't |
| 5. Where memory ends: hooks | 3 min | **Capstone** — memory suggests vs. a hook enforces; hooks that maintain memory |
| 6. Wrap + which-system-when | 3 min | Decision recap, pitfalls |

> **Time math:** fully loaded this runs ~34 min. The terminal section is intentionally over-stuffed — the ★ beats are the spine (centerpiece, loading model, `#`→auto-memory, `/memory`, hierarchy); drop the non-starred beats (read-the-file, `@`-imports, auto-memory-in-action) first. If you're hard-capped at 30, see the "running short" note in §5 and trim Demo B to its ★ beats. The capstone and the centerpiece are the parts a dev audience remembers — protect those.

The big idea to keep returning to: **"Claude Memory" is not one feature — it's three separate systems that do not share data.** Every section reinforces that.

---

## 0. Cold open (1 min)

Open Claude Code (or the app) in a state where it knows nothing and ask: *"What were we working on yesterday?"* — let it come up blank. Then say:

> "Every LLM has the same disability: it forgets everything the moment a session ends. The whole topic today is the three different ways Claude gets around that — and when to use each one."

Show **Visual 1 (Blank Slate)**.

---

## 1. Theory (6 min)

### 1a. The stateless problem (~2 min) — Visual 1
Talk track:
- A model has no memory of its own. Each session starts from zero.
- Without help, you re-teach Claude your stack, your conventions, your preferences every single time — that's wasted tokens and wasted minutes.
- Memory is any mechanism that survives the end of a session and gets reloaded at the start of the next one.

### 1b. Context window ≠ memory (~2 min) — Visual 2
This is the distinction technical audiences most often blur:
- **Context window** = working memory for *this* session. Even at 1M tokens it's volatile — it disappears when the session ends. Think RAM.
- **Memory** = persists *across* sessions and gets *injected* into a fresh context window next time. Think disk.
- Punchline: *a giant context window does not give you memory.* You can have a million tokens of room and still start every session amnesiac.

### 1c. The three systems (~2 min) — Visual 3
- **claude.ai / the app:** Claude auto-summarizes your conversations and builds a synthesis of key insights across your chat history, refreshed every 24 hours and fed into each new chat. It's editable, project-scoped, and you can go incognito. Rolled out to all accounts (free and paid) in 2026.
- **Claude Code:** driven by `CLAUDE.md` files read at the start of every session, plus auto-memory that Claude writes itself from your corrections.
- **The API:** no persistent memory by default — each call starts fresh. You build your own (your DB, a RAG pipeline, or a memory tool).

> Say it out loud: **app memory and Claude Code memory are separate. Turning one on does nothing for the other.** This trips up almost everyone.

---

## 2. Demo A — the prompt (7 min)

**Environment:** claude.ai or the desktop/mobile app, memory enabled.

> ⚠️ **Pre-flight (do this the day before):** the app's synthesis refreshes roughly every 24h. On a fresh account it'll be empty. Have a few real conversations a day ahead so there's something to show. Confirm Settings → memory is enabled and you have one demo Project created.

### Beat 1 — "What do you know about me?" (~1.5 min)
Type it. Claude answers from the synthesis.
- Talk: "This isn't from this chat — it's the 24-hour synthesis of everything across my history, injected into every new conversation."

### Beat 2 — Show the memory is yours to see and edit (~1.5 min)
Open Settings → memory. Show the readable summary Claude keeps about you.
- Talk: "Unlike a black box, you can read it, and you can change it."

### Beat 3 — Correct a memory (~1.5 min)
Prompt: *"Update your memory: my main language is now Rust, not Python."*
- Talk: "When memory is wrong or stale, you correct it in plain language — or edit it directly in settings."

### Beat 4 — Teach a durable preference (~1 min)
Prompt: *"Remember that I prefer concise answers and no bullet points."*
- Talk: "Now I never have to say that again — in any future chat."

### Beat 5 — Project isolation (~1.5 min)
Open a Project. Show it has its own separate memory space.
- Talk: "Each project is a walled garden. My screenplay notes never bleed into my infra work. If I drift off-topic inside a project, Claude will actually push back — 'I thought we were working on X.'"

### Beat 6 — Incognito (~1 min)
Start an incognito chat.
- Talk: "Nothing here is saved or synthesized. This is your clean-room mode for one-offs and sensitive stuff."

**Fallback line if memory looks empty:** "Synthesis runs every 24 hours, so on a fresh account you'd seed it the day before — here's what a lived-in profile looks like." (Then switch to your pre-seeded account or a screenshot.)

---

## 3. Demo B — the terminal (11 min)

**Environment:** Claude Code in a sample repo. Use a recent version (auto-memory needs v2.1.59+; the `#` shortcut has had version-specific bugs — saying "remember that…" in plain language is the reliable fallback).

> ⚠️ **Pre-flight:** clone a small sample repo; have both a `~/.claude/CLAUDE.md` (user) and a `./CLAUDE.md` (project) ready to show; have the demo files (`CLAUDE.lean.demo.md`, `CLAUDE.lean.md`, `CLAUDE.bloated.md`) on hand for the centerpiece; **run `/context` once beforehand with the demo copy and the bloated file and write down your real token numbers** so you can narrate them confidently; bump your terminal font; record a backup screen capture in case the live run misbehaves.

Core beats are marked ★ — drop the non-starred beats first if you're running long.

### Beat 0 ★ — The launch tax: how memory pollutes context (~3 min) — Visual 6
This is the centerpiece. It turns "memory is context, not config" into something the room can *see*.

**Setup:** two copies of the same project's memory file — `CLAUDE.lean.demo.md` (tidy, **imports stripped** for this demo) and `CLAUDE.bloated.md` (bloat, contradictions, stale facts, personality noise). Keep `CLAUDE.lean.md` (with the `@`-imports) around as your *realistic* template — just don't use it for the token A/B, because the imported docs inflate the "lean" number and it can come out *larger* than the bloated file (see the import gotcha below).

> **Recorded numbers (fill in yours during pre-flight):** lean (no imports) ≈ **628 tokens, ~0.3%**. Bloated ≈ **[record yours — expect several× larger]**. Run `/context` against each on your own machine and write the real figures here so your talk track quotes facts, not placeholders.

1. Copy the lean file in: `cp CLAUDE.lean.demo.md CLAUDE.md`, launch Claude Code, run `/context`.
    - Point at the **memory files** row: a sliver, ~0.3%. Free space wide open.
    - Talk: "I have not typed a single character. This is what my memory *costs* — basically nothing."
2. Swap in the bad file: `cp CLAUDE.bloated.md CLAUDE.md`, **fully relaunch Claude Code** (CLAUDE.md is read once at startup — swapping it mid-session changes nothing), run `/context` again.
    - The **memory files** row jumps several times higher. Free space visibly shrinks.
    - Talk: "Same project, still zero characters typed — but look how much of my window is already gone. And this loads again on *every single message*, not just the first."
3. Now probe the *behavior*. Two honest options here — pick based on your repo:
    - **If you're in a real spring-petclinic clone (there's a `pom.xml`):** don't ask a verifiable fact — Claude will just read the `pom.xml` and answer correctly, ignoring the file's lies. **That resistance IS the lesson.** Say: "I stuffed this file with wrong facts and a 'Captain' persona. Watch — Claude fact-checks me against the actual `pom.xml` and ignores the theatrics. That's the whole point: **CLAUDE.md suggests, it doesn't control.**" → hand straight to the hooks capstone.
    - **To surface the contradiction tax instead:** give it a *task* the bad rules conflict on, e.g. *"Add an `email` field to the `Owner` entity."* The clashing rules (tabs vs. spaces, Lombok vs. not, field vs. constructor injection) force a choice, so you'll more often see it hedge, ask which convention, or waste output reconciling the mess. Not guaranteed — strong models often just pick a sane default silently — so don't script it as a sure thing.
4. Land the lesson: "Everything in CLAUDE.md is pre-loaded context that reloads every message. Keep it lean, keep it true, keep it consistent — bloat is a token tax, contradictions are a quality tax, and either way you pay on token one."

**Optional reveal — imports count as memory too (~30s):** this is the bug you'll hit in prep, turned into a feature. Re-add `See @README.md` to the lean file, relaunch, `/context` — the "lean" number jumps right back up, because Claude Code pulls imported files *into* the memory count. Talk: "An import is just memory wearing a trench coat. A file that *looks* tidy isn't lean if it `@`-imports your whole README."

> **Fallback:** if a live relaunch is risky, run `/context` once per file ahead of time and screenshot both breakdowns; flip between them. The token-cost contrast in steps 1–2 is pure math and always lands — lead with it. Don't bet the demo on step 3's behavior firing a particular way.

### Beat 0b ★ — How memory actually loads: the three tiers (~1.5 min) — Visual 8
Natural follow-on to the centerpiece: "You just saw the cost of bad memory. Here's the smarter loading model auto-memory uses to avoid exactly that." Three tiers, only the first two cost you at startup:

- **CLAUDE.md → always loaded, in full, uncapped.** Resident in context every message. This is the tier where bloat actually hurts (your Beat 0 point).
- **Auto-memory index (`MEMORY.md`) → always loaded, but capped** at the first 200 lines / 25KB. A deliberately small table of contents.
- **Auto-memory topic files (`debugging.md`, `patterns.md`, …) → lazy.** Not loaded at startup; Claude reads one on demand (the "Recalled memory" indicator) only when the index points at something relevant.

- Talk: "This is *why* `#` writes to a separate auto-memory store instead of appending to CLAUDE.md. Appending everything to CLAUDE.md is the uncapped bloat we just punished. Auto-memory keeps a tiny always-loaded index and pushes the bulk into files that pay zero startup tax."
- **Caveat for Q&A:** how Claude decides a topic file is relevant isn't fully documented — describe it as "reads the relevant ones on demand," don't over-claim the retrieval internals.

### Beat 1 — Cold start (~1 min)
Fresh session in a repo with *no* CLAUDE.md, ask: *"What do you know about this project?"* → it knows nothing.
- Talk: "Same blank slate from Visual 1 — but the fix here is completely different from the app."
- *(Skip this if Beat 0 ran long — the launch-tax demo already showed memory loading at startup.)*

### Beat 2 ★ — `/init` (~1.5 min)
Run `/init`. Claude scans the repo and writes a starter `CLAUDE.md` in ~30 seconds.
- Talk: "Roughly an 80% starting point — build commands, conventions, layout — that you then refine."

### Beat 3 — Read the file (~1 min)
`cat CLAUDE.md`. Walk the structure: overview, stack, conventions, "always do X" rules.

### Beat 4 ★ — The `#` quick-add → auto-memory (~1.5 min)
Type: `# Always run ./mvnw verify before suggesting a commit`
This does **not** append to `CLAUDE.md`. In current Claude Code, `#` (and plain "remember this…") writes to **auto-memory** — Claude's own notebook at `~/.claude/projects/<your-repo-path>/memory/` (the path is your repo path with slashes turned to hyphens, keyed to the git repo, so all subdirs/worktrees share it).
- Talk: "Two different stores. CLAUDE.md is what *you* tell Claude. Auto-memory is the notebook *Claude* keeps about your project — and `#` feeds the notebook."
- **Show where it landed:** `ls ~/.claude/projects/` then open the `memory/` folder — there's a `MEMORY.md` index plus topic files.
- **Gotcha to call out (you'll see this live):** run `/memory` and it looks like "just CLAUDE.md." That's because `/memory` *inlines* the CLAUDE.md / local / rules files but surfaces auto-memory as a **toggle + a link to open the folder**, not as inline text. Your new entry isn't missing — it's one click away in that folder.
- **Fallback:** behavior of `#` has shifted across versions; if it doesn't trigger, just say "remember that…" in plain language — same destination (auto-memory).

### Beat 5 ★ — `/memory` inspector (~1.5 min)
Run `/memory`. It lists the CLAUDE.md / local / rules files loaded this session (inlined), with an **auto-memory toggle** and a **link to the auto-memory folder**. Open a CLAUDE.md and edit/prune one line live (gently); point out the auto-memory toggle.
- Talk: "Your audit panel — what's loaded right now and where each piece came from. Note the split: CLAUDE.md shows inline, auto-memory is a toggle plus a folder link (that's the gotcha from the last beat)."
- Mention auto-memory can be disabled per session with `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1` or via the toggle here.

### Beat 6 — `@`-imports (~1 min) — Visual 4 reference
Show a `CLAUDE.md` line like `See @README.md and @docs/architecture.md`.
- Talk: "Import existing docs instead of copy-pasting them. Imports nest up to five levels deep. Keep one source of truth."

### Beat 7 ★ — Hierarchy (~1 min) — Visual 4
Show `~/.claude/CLAUDE.md` (your prefs, all projects) next to `./CLAUDE.md` (team, in git). Mention enterprise policy files sit above both for IT-managed orgs. Note `CLAUDE.local.md` is deprecated in favor of imports.
- Talk: "All loaded and merged at session start, and Claude reads recursively up the directory tree from where you are."

### Beat 8 — Auto-memory in action (~1 min) — Visual 5
Correct Claude: *"This project runs H2 in-memory by default, not Oracle."* Show it gets written back; start a new session and it remembers without you re-stating it.
- Talk: "This is the system teaching itself from your corrections. Toggle it per-session with `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1`."

---

## 4. Best practices (2 min)

Pitch these as rules of thumb, mostly Claude-Code-flavored since that's where devs have the most control:

- **Memory is context, not enforcement.** Claude treats `CLAUDE.md` as strong context, not a hard rule engine. If you need to *guarantee* a block, use a PreToolUse hook, not a memory line.
- **Store stable facts, not volatile ones.** Build commands, conventions, architecture, "always do X" — yes. Anything that changes weekly — no; it just adds noise.
- **Be specific and concise.** The tighter and more specific the instruction, the more consistently it's followed. Vague memory is weak memory.
- **Import, don't duplicate** — but know imports count as memory. `@README.md` beats pasting the README for maintainability, yet the imported file still loads into context and counts against your token budget. Don't `@`-import giant docs into a file you're calling "lean."
- **Mind the tiers.** `CLAUDE.md` is loaded in full and *uncapped* — that's where bloat hurts. The auto-memory index is capped (~200 lines / 25KB); keep it a true index and let topic files hold the detail.
- **Persistent rules survive compaction** if they live in `CLAUDE.md` — handy in long sessions.
- **Audit and prune.** Run `/memory` periodically; open the auto-memory folder and prune stale notes. In the app, re-read the synthesis and correct anything wrong.
- **Noise degrades quality.** A bloated memory is worse than a lean one. Curate.

---

## 5. Where memory ends: hooks (3 min) — capstone

The honest frame: **memory has a ceiling. It only *suggests*, and it grows by hand.** Hooks are the tool that picks up where memory stops. Two real relationships between memory and hooks — plus one thing that looks like memory but isn't. Show Visual 7, then walk these.

Hooks live in `.claude/settings.json` (project) or `~/.claude/settings.json` (user). Each fires on a lifecycle event and runs a script that can read session info on stdin and write decisions/context back out.

### A ★ — The contrast: memory *suggests*, a hook *enforces*
This is the direct payoff to your whole thesis, and it uses the Beat 4 callback. Two different mechanisms, same rule, different strength — a comparison, not a combination.

Callback: "Back in Beat 4 we wrote *'always run `./mvnw verify` before committing'* to auto-memory. That's advisory — Claude can still commit without it, because memory is context, not config." Then show the same rule as a `PreToolUse` hook on the `Bash` tool that denies `git commit` unless `./mvnw test` passed:
```json
{ "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Tests haven't passed — run ./mvnw test first." } }
```
Ask Claude to commit with a failing test in the tree → the commit is *blocked deterministically*, no matter what the model decided.
- Talk: "Same rule, two strengths. In memory it's a suggestion. In a hook it's a guarantee. If it *must* (or must not) happen, that's a hook — memory can't promise it."

### B ★ — The real overlap: a hook that *maintains* memory
This is the only pattern that genuinely combines the two — hooks that *write* memory so it grows without you typing `#` every time. A `Stop` or `SessionEnd` hook appends durable outcomes to a notes file, and an `@`-import surfaces them as memory next session:
```json
{ "hooks": {
    "SessionEnd": [ { "hooks": [ { "type": "command",
      "command": "echo \"- $(date +%F): $(git log -1 --format=%s)\" >> .claude/decisions.md" } ] } ] } }
```
Then `CLAUDE.md` contains `See @.claude/decisions.md`. Loop closed: the hook *writes* memory, the import *loads* it.
- Talk: "Memory that maintains itself. This is the spirit of what auto-memory and session-memory automate for you under the hood."
- **Dragons:** easy to make memory noisy this way — append sparingly, prune often. (Straight back to the centerpiece: bloat is the enemy.)

### Aside — live-state injection is *not* memory
A `SessionStart` hook can run `git status`/`git branch` and inject the result into context. Useful, but be honest in the room: **that's dynamic context, not memory** — nothing is persisted or remembered, it's just read fresh each launch. (Point it at a persisted notes file and it edges back toward B.) Mention it in one line; don't sell it as memory.

> **Running short (hard 30-min cap):** demo **A only** — it's the cleanest landing of the talk's thesis and reuses the Beat 4 callback. Describe B with the Visual 7 callout; drop the aside. Or move the whole capstone to a "where to go next" closer and let it run into Q&A.

---

## 6. Wrap — which system, when (3 min)

### The decision table (say this slowly)
- Personal context that should follow you across chats → **app memory**
- Team conventions tied to a repo → **project `./CLAUDE.md`** (commit it)
- Your own coding preferences everywhere → **user `~/.claude/CLAUDE.md`**
- A rule that *must* hold no matter what → **`PreToolUse` hook** (memory only suggests)
- Memory that updates itself instead of by hand → **`Stop`/`SessionEnd` hook + `@`-import**
- Live per-session state (branch, build) → **`SessionStart` hook** — but that's context, not memory
- Building a product on the API → **roll your own** (DB / RAG / memory tool)

### Top pitfalls to call out
1. Expecting app memory to show up in Claude Code, or vice versa. **They're separate.**
2. Over-stuffing `CLAUDE.md` until quality drops.
3. Treating memory as a guarantee instead of context.
4. Forgetting app synthesis is ~24h delayed — which is why you seed demos early.

### Closing line
> "Three systems, one idea: stop re-explaining yourself. Pick the right one for where you're working, keep it lean, and let it compound."

---

## Appendix A — Presenter pre-flight checklist

**App**
- [ ] Memory enabled in Settings
- [ ] Account seeded with real conversations 24h+ in advance
- [ ] One demo Project created
- [ ] You know exactly where Settings → memory lives

**Claude Code**
- [ ] Updated to a recent version (verify `#` behavior + auto-memory ≥ v2.1.59)
- [ ] **PetClinic repo cloned** (Spring Boot 4.x, Maven), no pre-existing `CLAUDE.md` (so `/init` has something to do)
- [ ] `CLAUDE.lean.demo.md` (no imports), `CLAUDE.lean.md` (template, for the import reveal), and `CLAUDE.bloated.md` on hand; `/context` numbers for the demo copy + bloated written down
- [ ] A `~/.claude/CLAUDE.md` and a `./CLAUDE.md` prepared to show the hierarchy
- [ ] **Hooks ready:** a `.claude/settings.json` with the `PreToolUse` test-gate hook tested once (the §5 "A" demo); optionally the `SessionEnd`→decisions-file hook for "B"
- [ ] Terminal font bumped; backup screen recording captured

**Both**
- [ ] All eight visuals on a second screen or printed
- [ ] Fallback lines rehearsed

---

## Appendix B — The ASCII visuals

### Visual 1 — The Blank Slate (stateless problem)
```
   Session 1            Session 2            Session 3
 ┌───────────┐        ┌───────────┐        ┌───────────┐
 │ you teach │        │ you teach │        │ you teach │
 │ Claude    │   ✗    │ Claude    │   ✗    │ Claude    │
 │ everything│  wiped │ everything│  wiped │ everything│
 │  ...again │ ─────► │  ...again │ ─────► │  ...again │
 └───────────┘        └───────────┘        └───────────┘
       ▲                    ▲                    ▲
       └── starts blank ────┴──── starts blank ──┘

        No memory = re-teach everything, every time.
```

### Visual 2 — Context Window vs. Memory
```
  CONTEXT WINDOW                         MEMORY
  (this session only)                    (persists across sessions)
  ┌────────────────────┐                ┌────────────────────┐
  │ system prompt      │                │ synthesized facts  │
  │ + your messages    │   session      │ + your preferences │
  │ + Claude's replies │   ends ───►    │ + project notes    │
  │ + tool outputs     │   GONE         │      ...survives   │
  └────────────────────┘                └─────────┬──────────┘
       volatile  ≈ RAM                            │ injected at
       (even at 1M tokens)                        ▼ next start
                                          ┌────────────────────┐
                                          │   new context      │
                                          │   (pre-loaded)     │
                                          └────────────────────┘

        A big context window is NOT memory.
```

### Visual 3 — The Three Systems
```
                      "CLAUDE MEMORY"
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
 ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
 │ claude.ai /  │    │ Claude Code  │    │   the API    │
 │   the app    │    │  (terminal)  │    │              │
 ├──────────────┤    ├──────────────┤    ├──────────────┤
 │ 24h synthesis│    │ CLAUDE.md    │    │ none by      │
 │ chat search  │    │ files        │    │ default —    │
 │ project mem  │    │ auto-memory  │    │ you build it │
 │ editable     │    │ # / /memory  │    │ (DB / RAG /  │
 │ incognito    │    │ @-imports    │    │  memory tool)│
 └──────────────┘    └──────────────┘    └──────────────┘
        └──────  SEPARATE — do NOT share data  ──────┘
```

### Visual 4 — Claude Code's CLAUDE.md Hierarchy
```
  All loaded + merged at session start; read recursively UP from cwd.

  ┌─ Enterprise policy ──────────────────────────────┐
  │  IT-managed CLAUDE.md   (whole org)              │
  └──────────────────────────────────────────────────┘
  ┌─ User memory ────────────────────────────────────┐
  │  ~/.claude/CLAUDE.md    (you, every project)     │
  └──────────────────────────────────────────────────┘
  ┌─ Project memory ─────────────────────────────────┐
  │  ./CLAUDE.md            (team, checked into git) │
  └──────────────────────────────────────────────────┘

   + @imports pull in other files   (e.g. @README.md, depth ≤ 5)
   + recursive load:  ./  →  ../  →  ...  →  /
   (CLAUDE.local.md is deprecated — use imports instead)
```

### Visual 5 — The Memory Loop
```
        ┌────────────────────────────────────────────┐
        │              YOU  +  CLAUDE                 │
        │   work · correct · state preferences        │
        └─────────────────────┬───────────────────────┘
                              │  Claude notices
                              │  "worth keeping"
                              ▼
                       ┌─────────────┐
                       │   MEMORY    │   app  → 24h synthesis
                       │   written   │   code → auto-memory
                       │             │          + # / /memory
                       └──────┬──────┘
                              │  loaded at the
                              │  start of...
                              ▼
        ┌────────────────────────────────────────────┐
        │            NEXT SESSION begins              │
        │        already knowing the above            │
        └────────────────────────────────────────────┘
```

### Visual 6 — The Launch Tax (context pollution)
```
  WHAT'S IN CONTEXT BEFORE YOU TYPE ANYTHING   (Claude Code · /context)

  LEAN  CLAUDE.md  (~0.4K tokens)
  ┌──────────────────────────────────────────────────────────┐
  │ system + tools ████████ │mem▏│ free ...................... │
  └──────────────────────────────────────────────────────────┘
                            ↑ <1%        plenty of room to work

  BLOATED  CLAUDE.md  (~several K tokens + contradictions + stale facts)
  ┌──────────────────────────────────────────────────────────┐
  │ system + tools ████████ │mem ██████│ free ............... │
  └──────────────────────────────────────────────────────────┘
                            ↑ several %, and it reloads on EVERY message
                            ↑ PLUS Claude misbehaves on turn one:
                              "Captain! 🚀" · says Gradle + Spring Boot 2.7
                              (it's Maven + 4.x) · insists on javax.*

        Memory is pre-loaded context. Bad memory = a tax on token one.
```

### Visual 7 — Where memory ends: hooks
```
   ┌─ MEMORY ───────────────┐        ┌─ HOOKS ─────────────────────┐
   │ what Claude KNOWS       │        │ what Claude DOES             │
   │                         │        │ (deterministic scripts)      │
   │ CLAUDE.md + auto-memory │        │ PreToolUse   → ENFORCE       │
   │ • advisory: it SUGGESTS │        │ Stop/SessionEnd → WRITE      │
   │ • grows by hand   (#)   │        │                              │
   └─────────────────────────┘        └──────────────────────────────┘

   (1) CONTRAST — same rule, two strengths:
       "run ./mvnw verify before commit"
            in memory  =  suggestion   (Claude can skip it)
            in a hook  =  guarantee    (commit blocked)

   (2) OVERLAP — the real "memory + hooks":
       Stop/SessionEnd hook ──writes──► decisions file ──@import──► memory
       (memory that maintains itself, instead of typing # every time)

   aside: a SessionStart hook can inject live git state —
          that's dynamic CONTEXT, not memory.

   Memory suggests, and grows by hand.  Hooks enforce — and can grow it for you.
```

### Visual 8 — How memory loads: three tiers
```
  AT SESSION START                                  cost on every message?
  ─────────────────────────────────────────────────────────────────────
  CLAUDE.md            ████████████  loaded IN FULL      YES — uncapped
  (./ + ~/.claude)                   (bloat hurts here)

  MEMORY.md (index)    ███           loaded, but CAPPED   YES — but small
  auto-memory TOC                    (first 200 lines /        (≤200 lines)
                                      25KB, whichever first)

  topic files          ·             NOT loaded            NO — lazy
  debugging.md                       read ON DEMAND when        (zero
  patterns.md  …                     the index points to it     startup tax)
  ─────────────────────────────────────────────────────────────────────
  Why # writes to auto-memory, not CLAUDE.md: a tiny always-loaded index
  + lazy detail beats dumping everything into the uncapped tier.
```

---

## Appendix C — References (for your own verification)

- App memory & chat search — support.claude.com/en/articles/11817273
- Claude Code memory (CLAUDE.md, auto-memory) — code.claude.com/docs/en/memory
- Claude Code memory hierarchy & imports — docs.anthropic.com/en/docs/claude-code/memory
- The context window & what loads before you type — code.claude.com/docs/en/context-window
- Hooks reference (SessionStart, PreToolUse, additionalContext) — code.claude.com/docs/en/hooks
- `/context`, `/memory`, `/init`, `#` shortcut — Claude Code slash-command references
- Spring Boot 4.0 / Spring Framework 7 release notes — spring.io/blog (Nov 2025)

*Verify version-specific behavior (`#`, auto-memory, `/context` numbers, hook JSON fields) against your installed Claude Code build before presenting.*