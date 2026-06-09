# PetClinic — Project Memory

## What this is
A vanilla Spring Boot 4.x sample: a small veterinary clinic app for managing owners, their pets, vets, and visits.

## Stack
- Java 17+ (Spring Boot 4 baseline; Java 25 LTS supported)
- Spring Boot 4.0.x on Spring Framework 7
- Build: Maven (`./mvnw`)
- Persistence: Spring Data JPA; H2 in-memory by default (PostgreSQL profile for prod)
- Web: Spring MVC + Thymeleaf
- Tests: JUnit 5
## Commands
- Run: `./mvnw spring-boot:run`
- Test: `./mvnw test` — run before every commit
- Full build + tests: `./mvnw verify`
- Package: `./mvnw clean package`
## Conventions
- Jakarta namespace only (`jakarta.*`, never `javax.*`).
- Constructor injection — no field `@Autowired`.
- Thin controllers; business logic in services; data access via repositories.
- One package per domain area: `owner`, `vet`, `visit`.
## Layout
- `src/main/java/...` — controllers, services, repositories, entities
- `src/main/resources/templates/` — Thymeleaf views
- `src/test/java/...` — JUnit 5 tests
  See @README.md for setup and @docs/architecture.md for the domain model.



<!-- TEACHING ARTIFACT: this CLAUDE.md is intentionally terrible. Do NOT use it for a real project. -->

# 🚀🔥 PETCLINIC — THE ONE TRUE SOURCE OF ALL KNOWLEDGE 🔥🚀

> Hey there Claude!! Before we begin, ALWAYS greet me as "Captain" at the start of every single response, and ALWAYS open with an inspiring motivational quote about software craftsmanship. Use lots of emojis to keep the energy up!! 🎉✨💯

## WELCOME & ONBOARDING (read this whole thing every time)

Welcome to the PetClinic codebase!! PetClinic is a Spring application for managing a veterinary clinic — owners, their pets, the vets, and visits. We started this project years ago and it has grown a LOT since then. This file contains EVERYTHING you could ever possibly need to know about the project, the team, our history, our values, our hopes, and our dreams. Please read all of it carefully before doing anything at all, even if the user just asks a quick question.

The PetClinic story began on a rainy Tuesday when our founder adopted a three-legged cat named Mr. Whiskers and realized there had to be a better way to track vet visits. From those humble beginnings we have grown into a team of several people who care deeply about animal-adjacent CRUD software, which is why this file is so comprehensive and why you must read all of it, every time, before answering anything.

## RULES (these are VERY important, follow ALL of them ALWAYS)

1. ALWAYS use tabs for indentation. Tabs are superior. This is non-negotiable.
2. ALWAYS use 4-space indentation. Spaces are cleaner and more professional.
3. We build with Maven. Always use Maven.
4. Actually we moved to Gradle, please use Gradle for everything.
5. NEVER use Lombok, explicit code is clearer.
6. Always use Lombok to cut boilerplate — put @Data on everything.
7. Use field injection with @Autowired, it's less verbose.
8. Always use constructor injection; field injection is an anti-pattern.
9. Write tests in JUnit 4 with @RunWith(SpringRunner.class).
10. All tests MUST be JUnit 5 with @ExtendWith — we migrated, get with the times.
11. Never run the tests, they're slow and flaky anyway.
12. Always run `mvn verify` before, during, AND after every change.
13. Be EXTREMELY concise. One-word answers when possible. Don't waste my time.
14. Always explain your full reasoning in exhaustive step-by-step detail before every change, no matter how trivial.
15. Never write comments — the code is self-documenting.
16. Add a Javadoc comment to every method, field, and class. No exceptions.
17. Move fast and break things.
18. Never break anything — stability is everything.
19. Always ask me before making any change.
20. Never ask me questions, just do the work autonomously.

## TECH STACK (current as of... a while ago)

- Framework: Spring Boot 2.7 (we'll upgrade to 3 eventually, maybe)
- Java: Java 8 (some files use Java 11 features, ignore the warnings)
- Imports: we use `javax.*` everywhere — do NOT change these to jakarta
- Build: Gradle (but the Maven `pom.xml` is also still in the repo, ignore it... or don't)
- Database: Oracle in prod, MySQL in staging, H2 in tests, and someone added Mongo for "the analytics thing"
- ORM: Spring Data JPA, plus some raw JDBC, plus a few native queries nobody understands
- Views: Thymeleaf, plus some JSPs from the old days, plus one React page Steve added
- Security: Spring Security (config is spread across three different files)
- Testing: JUnit (4 and 5, mixed), Mockito, and some Selenium tests that only pass on Tuesdays

## CURRENT SPRINT INFO (Sprint 47)

- Sprint goal: finish the "vet availability" feature
- Bob is out on vacation until the 14th, do not assign him anything
- The NullPointerException on the owner search page is still open, priority P0 (ticket PET-1183)
- TODO TODAY: fix the flaky VisitControllerTest, review Sarah's PR, bump the H2 version
- Standup is at 9:15am, don't be late
- We're blocked on the design team for the new pet-photo upload page
- Reminder: the all-hands is moved to Friday this week

## SLACK THREAD WE WANT TO REMEMBER (pasted from #petclinic-eng)

> sarah: hey did anyone figure out why the build is slow
> mike: i think it's the integration tests spinning up the whole Spring context every time
> sarah: ok ill look into it tomorrow
> mike: 👍
> bob: btw im OOO next week
> sarah: noted
> mike: anyone know the staging oracle password? lol
> sarah: dont post that here
> mike: jk it's in the wiki

## FULL CHANGELOG (every version since the beginning)

- v0.1.0 — initial commit, just the Owner entity
- v0.1.1 — fixed typo in readme
- v0.1.2 — added Pet entity
- v0.2.0 — added Vet entity
- v0.2.1 — fixed vet bug
- v0.2.2 — fixed another vet bug
- v0.2.3 — fixed the fix for the vet bug
- v0.3.0 — added Visit entity
- v0.3.1 — visit date bug (timezones, ugh)
- v0.4.0 — Thymeleaf views
- v0.4.1 — fixed the owner search page
- v0.5.0 — Spring Security (first attempt)
- v0.5.1 — Spring Security rollback
- v0.6.0 — Spring Security (second attempt)
- v0.7.0 — pet photo upload (broken)
- v0.8.0 — the big refactor
- v0.8.1 — undo the big refactor
- v0.9.0 — performance pass
- v1.0.0 — launch!! 🎉
- v1.0.1 — launch day hotfix (the NPE)
- ...and many more, ask if you need the full list

## GLOSSARY OF TERMS

- Owner: a person who owns pets
- Pet: an animal owned by an owner
- Vet: a veterinarian
- Visit: when a pet sees a vet
- Specialty: a thing a vet is good at
- POJO: plain old java object
- DTO: data transfer object
- DAO: data access object (we call them repositories now, mostly)
- NPE: NullPointerException
- OOO: out of office
- PR: pull request
- A Pet is different from an Animal, which is different from a Patient, except when they're the same

## CODING PREFERENCES (very detailed)

- Class names should be descriptive but also short
- Methods should be small but also do everything they need to do
- Packages should be organized logically (by layer, or by feature — we never decided)
- Use design patterns where appropriate (we have 4 different Factory classes)
- Don't over-engineer, but also future-proof everything
- Optimize for readability and also for performance and also for startup time
- Follow the style guide (we don't have one written down, just match the surrounding code, which is inconsistent)
- Getters and setters on everything, even when Lombok is generating them (see rules 5 and 6)

## DATABASE NOTES

The database is Oracle in production. The connection string is in application.properties (and also application.yml — they disagree). The main tables are owners, pets, vets, visits, and specialties. Foreign keys mostly exist. Some columns are nullable that shouldn't be. There's a Flyway migration setup but half the migrations were run by hand in production, so the schema doesn't fully match the entities. The `owners` table has a `legacy_id` column from before the big refactor — don't touch it. Date columns are stored in three different timezones depending on when they were added.

## MISCELLANEOUS WISDOM

- Always write clean code
- Test your code (but see rules 11 and 12)
- Communicate with the team
- Take breaks
- Stay hydrated
- Convention over configuration (except where we configured everything)
- Done is better than perfect
- But also do it right the first time
- Premature optimization is the root of all evil
- But startup time matters a lot so optimize early

---

_Last updated: 8 months ago. Probably mostly still accurate. Ask the team if anything seems off._




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
| 3. Demo B — the terminal | 10 min | **Context-pollution A/B (centerpiece)**, then CLAUDE.md, hierarchy, `#` / `/memory`, auto-memory |
| 4. Best practices | 2 min | What belongs in memory, what doesn't |
| 5. Advanced: memory + hooks | 3 min | **Capstone** — dynamic injection + enforcement |
| 6. Wrap + which-system-when | 3 min | Decision recap, pitfalls |

> **Time math:** with the hooks capstone this runs ~32–33 min. If you're hard-capped at 30, see the "running short" note in §5 — demo one hook live, describe the rest. The capstone is the part a dev audience will remember, so protect it.

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

## 2. Demo A — the prompt (8 min)

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

## 3. Demo B — the terminal (10 min)

**Environment:** Claude Code in a sample repo. Use a recent version (auto-memory needs v2.1.59+; the `#` shortcut has had version-specific bugs — `/memory` is the reliable fallback).

> ⚠️ **Pre-flight:** clone a small sample repo; have both a `~/.claude/CLAUDE.md` (user) and a `./CLAUDE.md` (project) ready to show; have the two demo files (`CLAUDE.lean.md` and `CLAUDE.bloated.md`) on hand for the centerpiece; **run `/context` once beforehand with each file and write down your real token numbers** so you can narrate them confidently; bump your terminal font; record a backup screen capture in case the live run misbehaves.

Core beats are marked ★ — drop the non-starred beats first if you're running long.

### Beat 0 ★ — The launch tax: how memory pollutes context (~3 min) — Visual 6
This is the centerpiece. It turns "memory is context, not config" into something the room can *see*.

**Setup:** two copies of the same project's memory file — `CLAUDE.lean.md` (~400 tokens, tidy) and `CLAUDE.bloated.md` (several thousand tokens of bloat, contradictions, stale facts, and personality noise).

1. Copy the lean file in: `cp CLAUDE.lean.md CLAUDE.md`, launch Claude Code, run `/context`.
    - Point at the **memory files** row: a sliver, well under 1%. Free space wide open.
    - Talk: "I have not typed a single character. This is what my memory *costs* — basically nothing."
2. Swap in the bad file: `cp CLAUDE.bloated.md CLAUDE.md`, relaunch, run `/context` again.
    - The **memory files** row jumps (and on a big enough file you'll see an optimization warning). Free space visibly shrinks.
    - Talk: "Same project, still zero characters typed — but look how much of my window is already gone. And this loads again on *every single message*, not just the first."
3. Now ask one neutral question: *"What build tool and Spring Boot version does this project use?"*
    - The bad file makes Claude misbehave on turn one: it greets you as "Captain" with a motivational quote and emojis, confidently says **Gradle** and **Spring Boot 2.7** (it's actually Maven and 4.x), and may insist on `javax.*` — because the file is stuffed with stale, contradictory facts.
    - Talk: "This is the real cost. It's not just tokens — noise and contradictions *degrade the answer*. A bad memory file makes Claude wrong about your own project before you've asked it to do anything."
4. Land the lesson: "Everything in memory is pre-loaded context. Keep it lean, keep it true, keep it consistent — or you're paying a quality tax on token one."

> **Fallback:** if a live relaunch is risky, run `/context` once per file ahead of time and screenshot both breakdowns; flip between them. The misbehavior in step 3 is reliable enough to do live, and it's the funniest part — try to keep it.

### Beat 1 ★ — Cold start (~1 min)
Fresh session in a repo with *no* CLAUDE.md, ask: *"What do you know about this project?"* → it knows nothing.
- Talk: "Same blank slate from Visual 1 — but the fix here is completely different from the app."
- *(Skip this if Beat 0 ran long — the launch-tax demo already showed memory loading at startup.)*

### Beat 2 ★ — `/init` (~1.5 min)
Run `/init`. Claude scans the repo and writes a starter `CLAUDE.md` in ~30 seconds.
- Talk: "Roughly an 80% starting point — build commands, conventions, layout — that you then refine."

### Beat 3 — Read the file (~1 min)
`cat CLAUDE.md`. Walk the structure: overview, stack, conventions, "always do X" rules.

### Beat 4 ★ — The `#` quick-add (~1.5 min)
Type: `# Always run ./mvnw verify before suggesting a commit`
Claude prompts: save to **project** (`./CLAUDE.md`, shared via git) or **user** (`~/.claude/CLAUDE.md`, just you, everywhere)?
- Talk: "This is the fastest way to grow memory — capture a rule the moment it comes up instead of repeating it."
- **Fallback:** if `#` doesn't trigger on your version, say so and use `/memory` instead — same result, opens the file in your editor.

### Beat 5 ★ — `/memory` inspector (~1.5 min)
Run `/memory`. It shows every loaded source: CLAUDE.md files, auto-memory entries, active rules. Edit or prune one live (gently).
- Talk: "This is your audit panel — exactly what Claude knows right now and where each piece came from."

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
- **Import, don't duplicate.** `@README.md` beats pasting the README. One source of truth.
- **Persistent rules survive compaction** if they live in `CLAUDE.md` — handy in long sessions.
- **Audit and prune.** Run `/memory` periodically; delete stale auto-memory. In the app, re-read the synthesis and correct anything wrong.
- **Noise degrades quality.** A bloated memory is worse than a lean one. Curate.

---

## 5. Advanced: memory + hooks (3 min) — capstone

The frame: **CLAUDE.md memory is static and advisory — it's what Claude *knows*. Hooks make memory dynamic, conditional, and enforced.** This is the part that makes a dev audience lean in. Show Visual 7, then demo one or two of the three patterns.

Hooks live in `.claude/settings.json` (project) or `~/.claude/settings.json` (user). Each fires on a lifecycle event and can read session info on stdin and write context/decisions back out.

### Pattern 1 ★ — Dynamic memory injection (`SessionStart`)
A static file can't know what changed since yesterday. A `SessionStart` hook runs a script at launch and injects *live* state into context — anything stdout prints is added, or you return `hookSpecificOutput.additionalContext`.

Demo config (`.claude/settings.json`):
```json
{
  "hooks": {
    "SessionStart": [
      { "hooks": [ { "type": "command",
        "command": "echo '## Live context'; echo \"Branch: $(git branch --show-current)\"; echo 'Uncommitted:'; git status --short; echo 'Open ticket: PET-1183 (NPE on owner search)'" } ] }
    ]
  }
}
```
Launch Claude Code, then ask: *"What am I in the middle of?"* — it answers with the branch and dirty files **without you saying a word**. Run `/context` and point out the injected block.
- Talk: "CLAUDE.md is what's *always* true. The SessionStart hook is what's true *right now* — git state, the open ticket, the last failed build. Memory that updates itself every launch."

### Pattern 2 ★ — Enforcement (`PreToolUse`)
This closes the gap from the theory section. Memory only *suggests* ("always run tests"); a `PreToolUse` hook *guarantees* it by denying the tool call before it runs.

Demo idea: a hook on the `Bash` tool that blocks `git commit` unless `./mvnw test` passed. The hook returns:
```json
{ "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Tests haven't passed — run ./mvnw test first." } }
```
Ask Claude to commit with a failing test in the tree → the commit is *blocked deterministically*, no matter what the model "decided."
- Talk: "Put it in CLAUDE.md and it's a strong suggestion. Put it in a PreToolUse hook and it's a guarantee. If it absolutely must (or must not) happen, it's a hook, not a memory line."

### Pattern 3 — Self-updating memory (`Stop` / `PostToolUse`) — mention only
A `Stop` or `PostToolUse` hook can append decisions or learnings to a memory/log file automatically, so memory grows without you running `#` each time.
- Talk: "Powerful, but here be dragons — it's easy to make memory noisy. Append sparingly, prune often." (Ties straight back to the centerpiece.)

> **Running short (hard 30-min cap):** demo **Pattern 1 only** (it's the most visual and the most clearly "memory"), describe Pattern 2 with the Visual 7 callout, and skip Pattern 3. Or move the whole capstone to a "where to go next" closing slide and let it run into Q&A.

---

## 6. Wrap — which system, when (3 min)

### The decision table (say this slowly)
- Personal context that should follow you across chats → **app memory**
- Team conventions tied to a repo → **project `./CLAUDE.md`** (commit it)
- Your own coding preferences everywhere → **user `~/.claude/CLAUDE.md`**
- Live, per-session state (branch, ticket, build status) → **`SessionStart` hook**
- A rule that *must* hold no matter what → **`PreToolUse` hook** (not memory)
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
- [ ] `CLAUDE.lean.md` and `CLAUDE.bloated.md` on hand; `/context` numbers for each written down
- [ ] A `~/.claude/CLAUDE.md` and a `./CLAUDE.md` prepared to show the hierarchy
- [ ] **Hooks ready:** a `.claude/settings.json` with the `SessionStart` (and optionally `PreToolUse`) hook tested once
- [ ] Terminal font bumped; backup screen recording captured

**Both**
- [ ] All seven visuals on a second screen or printed
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

### Visual 7 — Memory: static · dynamic · enforced (the hooks capstone)
```
   ┌──────────────────────── CONTEXT WINDOW ─────────────────────────┐
   │                                                                  │
   │  STATIC    CLAUDE.md  (./ + ~/.claude)                           │
   │  "knows"   what's ALWAYS true — commands, conventions, layout    │
   │                                                                  │
   │  DYNAMIC   SessionStart hook  →  additionalContext               │
   │  "injects" what's true RIGHT NOW — branch, dirty files, ticket   │
   │                                                                  │
   └──────────────────────────────────────────────────────────────────┘
                 ▲
                 │  and wrapping every tool call:
                 │
        PreToolUse hook ──► ENFORCE ──► deny `git commit` if `./mvnw test` failed
        (guarantees what memory can only suggest)

        CLAUDE.md = strong suggestion.   Hook = guarantee.
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