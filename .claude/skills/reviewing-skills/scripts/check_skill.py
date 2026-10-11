#!/usr/bin/env python3
"""Deterministic best-practice checks for an Agent Skill.

Covers only the mechanical rules that are error-prone to eyeball: frontmatter validity
(name/description constraints from the official docs), SKILL.md body length, reference nesting
depth, missing tables of contents in long reference files, and Windows-style paths. Judgment
calls (description quality, conciseness, degrees of freedom) are left to the reviewer.

Usage:
    python3 check_skill.py <path-to-skill-directory-or-SKILL.md>

Exit code is 0 when there are no FAILs, 1 otherwise. Prints human-readable lines and a trailing
JSON object so a caller can fold results into a report.
"""
import json
import os
import re
import sys

# Official constraints (platform.claude.com Agent Skills docs).
NAME_MAX = 64
DESC_MAX = 1024
NAME_RE = re.compile(r"^[a-z0-9-]+$")
RESERVED = ("anthropic", "claude")
XML_TAG_RE = re.compile(r"<[^>]+>")
BODY_LINE_LIMIT = 500
TOC_LINE_THRESHOLD = 100
# First/second-person markers that signal a non-third-person description (English + Japanese).
POV_RE = re.compile(
    r"\b(I |I'|we |we'|you |you'|your )"
    r"|私|あなた|貴方|お手伝いし|してあげ|できます",
    re.IGNORECASE,
)
# Cues that the description says *when* to use the skill (English + Japanese).
TRIGGER_RE = re.compile(
    r"\b(use when|use whenever|use it when|use this when|when the user|when working"
    r"|for when|right after|before ship)"
    r"|とき|時に|場合|際に|求め|したい|ほしい|使う|使用",
    re.IGNORECASE,
)


def find_skill_md(path):
    if os.path.isfile(path):
        return path if os.path.basename(path) == "SKILL.md" else None
    candidate = os.path.join(path, "SKILL.md")
    return candidate if os.path.isfile(candidate) else None


def parse_frontmatter(text):
    """Return (frontmatter_dict, body_text). Minimal YAML: flat key: value pairs only."""
    if not text.startswith("---"):
        return {}, text
    parts = text.split("---", 2)
    if len(parts) < 3:
        return {}, text
    fm_raw, body = parts[1], parts[2]
    fm = {}
    key = None
    for line in fm_raw.splitlines():
        m = re.match(r"^([A-Za-z0-9_-]+):\s?(.*)$", line)
        if m:
            key = m.group(1)
            fm[key] = m.group(2).strip()
        elif key and line.strip():  # naive continuation for wrapped values
            fm[key] += " " + line.strip()
    return fm, body.lstrip("\n")


class Report:
    def __init__(self):
        self.checks = []
        self.failed = False

    def add(self, status, name, detail=""):
        self.checks.append({"status": status, "check": name, "detail": detail})
        if status == "FAIL":
            self.failed = True

    def emit(self):
        icon = {"PASS": "✅", "WARN": "⚠️ ", "FAIL": "❌"}
        for c in self.checks:
            line = f"{icon[c['status']]} [{c['status']}] {c['check']}"
            if c["detail"]:
                line += f" — {c['detail']}"
            print(line)
        print()
        print(json.dumps({"checks": self.checks, "has_failures": self.failed}, ensure_ascii=False))


def check_name(fm, r):
    name = fm.get("name", "")
    if not name:
        r.add("FAIL", "name present", "frontmatter has no `name`")
        return
    if len(name) > NAME_MAX:
        r.add("FAIL", "name length", f"{len(name)} chars (max {NAME_MAX})")
    else:
        r.add("PASS", "name length", f"{len(name)} chars")
    if NAME_RE.match(name):
        r.add("PASS", "name charset", "lowercase/digits/hyphens only")
    else:
        r.add("FAIL", "name charset", f"'{name}' must match ^[a-z0-9-]+$")
    hit = [w for w in RESERVED if w in name.lower()]
    if hit:
        r.add("FAIL", "name reserved words", f"contains {hit}")
    else:
        r.add("PASS", "name reserved words", "none")
    if XML_TAG_RE.search(name):
        r.add("FAIL", "name no XML", "contains XML-like tags")


def check_description(fm, r):
    desc = fm.get("description", "")
    if not desc:
        r.add("FAIL", "description present", "frontmatter has no `description`")
        return
    if len(desc) > DESC_MAX:
        r.add("FAIL", "description length", f"{len(desc)} chars (max {DESC_MAX})")
    else:
        r.add("PASS", "description length", f"{len(desc)} chars")
    if XML_TAG_RE.search(desc):
        r.add("FAIL", "description no XML", "contains XML-like tags")
    # Heuristic: descriptions should be third person. Flag, don't fail.
    if POV_RE.search(desc):
        r.add("WARN", "description third-person",
              "contains first/second-person wording; rewrite in third person")
    else:
        r.add("PASS", "description third-person", "no first/second-person openers")
    # Heuristic: should say *when* to use it, not just what it does.
    if TRIGGER_RE.search(desc):
        r.add("PASS", "description has trigger cue", "mentions when to use it")
    else:
        r.add("WARN", "description has trigger cue",
              "no explicit 'use when…' trigger; may under-trigger")


def check_body_length(body, r):
    lines = body.count("\n") + 1
    if lines > BODY_LINE_LIMIT:
        r.add("WARN", "SKILL.md body length",
              f"{lines} lines (>{BODY_LINE_LIMIT}); consider splitting into reference files")
    else:
        r.add("PASS", "SKILL.md body length", f"{lines} lines")


def linked_md_files(text, base_dir):
    """Markdown links pointing at local .md files that exist (deduplicated, order-preserving)."""
    out = []
    for target in re.findall(r"\]\(([^)]+)\)", text):
        target = target.split("#")[0].strip()
        if target.endswith(".md") and not target.startswith(("http://", "https://")):
            p = os.path.normpath(os.path.join(base_dir, target))
            if os.path.isfile(p) and p not in out:
                out.append(p)
    return out


def check_reference_depth_and_toc(skill_md, body, skill_dir, r):
    """References should be one level deep, and long ref files should have a TOC."""
    first_level = linked_md_files(body, skill_dir)
    deep = []
    for f in first_level:
        with open(f, encoding="utf-8", errors="replace") as fh:
            sub = fh.read()
        for g in linked_md_files(sub, os.path.dirname(f)):
            if os.path.normpath(g) != os.path.normpath(skill_md):
                deep.append((os.path.relpath(f, skill_dir), os.path.relpath(g, skill_dir)))
    if deep:
        pairs = "; ".join(f"{a} → {b}" for a, b in deep)
        r.add("WARN", "reference nesting depth",
              f"nested references found (keep one level deep from SKILL.md): {pairs}")
    else:
        r.add("PASS", "reference nesting depth", "references are one level deep")

    for f in first_level:
        with open(f, encoding="utf-8", errors="replace") as fh:
            content = fh.read()
        nlines = content.count("\n") + 1
        if nlines > TOC_LINE_THRESHOLD:
            has_toc = re.search(r"^#{1,3}\s+(contents|table of contents|目次)", content,
                                re.IGNORECASE | re.MULTILINE)
            rel = os.path.relpath(f, skill_dir)
            if has_toc:
                r.add("PASS", f"TOC in {rel}", f"{nlines} lines, has contents section")
            else:
                r.add("WARN", f"TOC in {rel}",
                      f"{nlines} lines (>{TOC_LINE_THRESHOLD}) but no '## Contents' section")


def check_windows_paths(skill_dir, r):
    # The docs' concern is path *references in instructions*. Scan markdown only; scanning source
    # files produces false positives on regex/escape backslashes.
    offenders = []
    for root, _, files in os.walk(skill_dir):
        for fn in files:
            if not fn.endswith(".md"):
                continue
            p = os.path.join(root, fn)
            with open(p, encoding="utf-8", errors="replace") as fh:
                for i, line in enumerate(fh, 1):
                    # backslash between path-like word chars, e.g. scripts\helper.py
                    if re.search(r"\b\w+\\[\w.\\]+\.(py|md|sh|js|ts|json)\b", line):
                        offenders.append(f"{os.path.relpath(p, skill_dir)}:{i}")
    if offenders:
        r.add("WARN", "no Windows-style paths", f"backslash paths at {offenders[:5]}")
    else:
        r.add("PASS", "no Windows-style paths", "all forward slashes")


def main():
    if len(sys.argv) != 2:
        print("usage: python3 check_skill.py <skill-dir-or-SKILL.md>", file=sys.stderr)
        sys.exit(2)
    skill_md = find_skill_md(sys.argv[1])
    if not skill_md:
        print(f"error: no SKILL.md found at {sys.argv[1]}", file=sys.stderr)
        sys.exit(2)
    skill_dir = os.path.dirname(os.path.abspath(skill_md))
    with open(skill_md, encoding="utf-8", errors="replace") as fh:
        text = fh.read()
    fm, body = parse_frontmatter(text)

    r = Report()
    if not fm:
        r.add("FAIL", "YAML frontmatter", "SKILL.md has no `---` frontmatter block")
    check_name(fm, r)
    check_description(fm, r)
    check_body_length(body, r)
    check_reference_depth_and_toc(skill_md, body, skill_dir, r)
    check_windows_paths(skill_dir, r)
    r.emit()
    sys.exit(1 if r.failed else 0)


if __name__ == "__main__":
    main()
