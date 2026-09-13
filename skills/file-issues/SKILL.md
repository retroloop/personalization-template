---
name: file-issues
description: File the approved records of a finished retrospective where you track issues, and mark them with your convention's label and attribute. Invoked by /retroloop:review after a review closes when Retroloop is set to track issues elsewhere.
argument-hint: "<retro id>"
---

# /my:file-issues — the approved records, filed where you track issues

Retroloop keeps the retrospective. It does not keep your work. When `tracking:`
in `retroloop.md` reads `elsewhere`, the session that closes a review runs this
skill with the retro id, and this skill puts the approved records into whatever
you actually use — GitHub, Asana, Linear, Jira, a plain file in a folder.

**This ships as a skeleton.** Steps 1, 3 and 4 are written; step 2 is yours,
because only you know your tracker. Every part you have to write is marked.

Run the app's CLI as `retroloop <args>` if the binary is on PATH, otherwise as
`cd ~/.retroloop/apps/retroloop && bun run --silent retroloop <args>`.

## 1 · Export the retrospective

```
retroloop export --retro <retroId> --out ~/.retroloop/retros/<retroId>/retro.json --json
```

`--json` prints a receipt — `{ path, records, bytes }` — instead of the export
itself. The retrospective is closed, so nothing in it can change any more and
the export is idempotent: the resolve lane may already have written this exact
file, and running it again writes the same one.

Read `records[]` and keep the entries whose `state` is `approved`. Each one
carries:

- `rid` and `num` — the record's names inside its retrospective
- `title`, `problem`, `rootCause` — what happened and why
- `solutions[]` and `selectedSolution` — the position of the one he chose,
  **1-based**: `2` is the second element. A 0-based read files the wrong
  solution and says nothing.
- `solutionLevel` and `involvement` — his ruling on how far the fix goes and
  how much of it he wants to be in
- `reviewerNote` — his words on the verdict
- `threads` — his comment threads on the record

Records in every other state are in the file too — decline is a state, not a
deletion — and none of them are yours to file.

## 2 · File one issue per approved record

> **Yours to fill in.** Everything in this step is an example of the shape, not
> a working command.

```
gh issue create --repo <owner/repo> \
  --title "<num> · <title>" \
  --body-file <the body you wrote for this record>
```

<!-- FILL IN: your tracker. Asana, Linear, Jira, a text file in a folder —
     anything goes here instead. Replace the command above with the one your
     tracker actually takes, and say where the body comes from. -->

The body carries the problem, the root cause, the selected solution and its
level, the involvement, and the human's own words — `reviewerNote` and what he
wrote in the threads, quoted rather than paraphrased away. His words are the
half of a record that does not survive being summarized.

One issue per approved record. **Never a declined one.** Keep a map of record
id → issue id as you go; steps 3 and 4 both read it.

## 3 · The label and the attribute your convention uses

Retroloop ships no labels — the convention is yours. The example convention: a
`migrated` label and an `external issue id` attribute of type `url`, created
once and reused by every run after.

```
retroloop label create "migrated" --json
retroloop attribute create "external issue id" --type url --json
```

<!-- FILL IN: your own words, if `migrated` and `external issue id` are not
     them. The attribute's type is one of number | text | url | date and can
     never be changed afterwards, so pick it once. -->

**Only when the human's AI-config-writes setting allows it.** That switch is on
his settings page and it starts off. Exit **5** is the answer when it is off:
say so in one line, and move on. Never retry it, never ask him to turn it on
mid-run, never route around it.

Putting the label on a record and setting its attribute value are his, in the
review UI — the CLI has no command for either, by design. So end this step by
listing record → issue id in one block, so he can do it in a single pass, or so
a future version of this skill can.

## 4 · Report

One line per filed record: its `num`, its title, and the issue id it got. Then
what was skipped and why — the records he did not approve, anything your tracker
refused, and the label and attribute if exit 5 turned them away.

---

Filing is not fixing. The resolve lane still applies the approved records
themselves: a retro approves a fix, the resolve lane's worker team builds it
here in this plugin, and the manager releases it. This skill only makes the
record visible where the rest of your work lives. The two do not interfere, and
neither one waits on the other.
