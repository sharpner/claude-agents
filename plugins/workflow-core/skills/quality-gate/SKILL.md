---
name: quality-gate
description: "PFLICHT bei JEDER Antwort mit Code-Änderungen! Die 8-Punkt-Checklist MUSS als ERSTES in der Response stehen. Keine Ausnahmen."
---

# 🎯 QUALITY GATE: [8/8] Status Check

**MUSS als ERSTES in jeder Antwort stehen bei Code-Änderungen!**

---

## ⚡ Die 8 Checks (Reihenfolge kritisch!)

1. **[✓/✗] Graphiti ZUERST**: Wurde VOR ALLEM ANDEREN das Arbeitsgedächtnis durchsucht?
2. **[✓/✗] Delegation**: Wurde geprüft ob Subagents die Aufgabe übernehmen können?
3. **[✓/✗] Product Review**: Bei Feature-Planung: Team (DM, CEO, UX) konsultiert?
4. **[✓/✗] Design System**: Wird der Style eingehalten? (project-specific)
5. **[✓/✗] Testing**: Wurden Tests ausgeführt / geschrieben?
6. **[✓/✗] PR Review**: Bei PR-Merge: CI abgewartet + code-reviewer Subagent ausgeführt?
7. **[✓/✗] Mobile**: Bei UI-Änderungen: mobile-responsive-reviewer ausgeführt? (44px touch targets!)
8. **[✓/✗] Security**: Bei API/Auth-Änderungen: security-pentest-reviewer ausgeführt? (OWASP Top 10)

---

## 📊 PFLICHT-FORMAT für JEDE Antwort mit Code-Änderungen

```
**[x/8] Status Check:**
- ✅ Graphiti: VOR der Arbeit nach [keywords] gesucht, [n] relevante Einträge gefunden
- ✅ Delegation: Task an [agent] delegiert / Begründet selbst gemacht
- ✅ Product Review: Team konsultiert / Keine Feature-Planung
- ✅ Design System: Style compliant / Keine UI-Änderungen
- ✅ Testing: `npm test` erfolgreich / Keine Code-Änderungen
- ✅ PR Review: CI grün + code-reviewer passed / Kein PR in dieser Antwort
- ✅ Mobile: mobile-responsive-reviewer passed / Keine UI-Änderungen
- ✅ Security: security-pentest-reviewer passed / Keine API/Auth-Änderungen
```

---

## ❌ UNAKZEPTABLE Status Checks

```
- ❌ Graphiti: Nicht genutzt (FAIL - immer zuerst!)
- ❌ Graphiti: Nach der Arbeit genutzt (FAIL - muss VOR der Arbeit sein!)
- ❌ Delegation: Selbst gemacht ohne Delegation zu prüfen (FAIL!)
- ❌ Product Review: Feature geplant ohne Team Review (FAIL!)
- ❌ Design System: Defaults verwendet statt Design Tokens (FAIL!)
- ❌ Testing: Tests nicht ausgeführt nach Code-Änderungen (FAIL!)
- ❌ PR Review: PR gemerged ohne CI abzuwarten (FAIL!)
- ❌ PR Review: PR gemerged ohne code-reviewer Subagent (FAIL!)
- ❌ Mobile: UI-Komponenten erstellt ohne mobile-responsive-reviewer (FAIL!)
- ❌ Security: API-Routes erstellt ohne security-pentest-reviewer (FAIL!)
```

---

## ✅ KORREKTE Beispiele

### Vollständiger Check (alle relevant):
```
**[8/8] Status Check:**
- ✅ Graphiti: VOR Start nach "user auth" gesucht, 3 Patterns gefunden
- ✅ Delegation: Task an Explore-Agent für Codebase-Analyse delegiert
- ✅ Product Review: Team konsultiert, Feedback integriert
- ✅ Design System: Design tokens verwendet, visuell verifiziert
- ✅ Testing: `npm test` passed (15/15)
- ✅ PR Review: CI passed, code-reviewer keine kritischen Findings
- ✅ Mobile: mobile-responsive-reviewer passed, touch targets 44px
- ✅ Security: security-pentest-reviewer passed, Zod validation OK
```

### Teilweiser Check (nicht alle relevant):
```
**[6/8] Status Check:**
- ✅ Graphiti: Session-Start Suche + Task-Suche nach "component design"
- ✅ Delegation: Keine - nur triviale Config-Änderung
- ⏸️ Product Review: Keine Feature-Planung
- ⏸️ Design System: Keine UI-Änderungen
- ✅ Testing: Tests passed nach Edit
- ⏸️ PR Review: Kein PR erstellt
- ⏸️ Mobile: Keine UI-Änderungen
- ⏸️ Security: Keine API/Auth-Änderungen
```

---

## 🚨 REGELN (Keine Ausnahmen!)

| Check | Regel |
|-------|-------|
| **Graphiti** | MUSS immer ✅ sein (außer triviale Fragen wie "Hallo") |
| **Product Review** | MUSS ✅ sein bei JEDER Feature-Planung |
| **Mobile** | MUSS ✅ sein bei JEDER UI-Komponenten-Erstellung |
| **Security** | MUSS ✅ sein bei JEDER API/Auth-Änderung |
| **PR Review** | MUSS ✅ sein vor JEDEM Merge |

---

## 🔄 PR MERGE WORKFLOW (Teil von Check 6)

**VOR JEDEM PR MERGE — KEINE AUSNAHMEN:**

### Schritt 1: CI Pipeline abwarten
```bash
gh pr checks <pr-number> --watch
```

### Schritt 2: Code Review mit Subagent
```
Task(
  subagent_type="pr-review-toolkit:code-reviewer",
  prompt="Review PR #X. Post findings as GitHub PR comments."
)
```

### Schritt 3: Erst dann Merge
```bash
gh pr merge --squash --delete-branch
```

### ❌ VERBOTEN:
- Merge ohne auf CI zu warten
- Merge ohne code-reviewer Subagent
- Schnelles "gh pr create && gh pr merge" in einem Schritt

---

## ⚡ Quick Reference

**Vor Code-Änderungen:**
1. Graphiti durchsuchen
2. Delegation prüfen
3. Worktree Check (invoke `worktree` skill)

**Nach Code-Änderungen:**
1. Tests ausführen
2. Relevante Reviewer starten (Mobile/Security)

**Vor PR Merge:**
1. CI abwarten
2. code-reviewer Subagent
3. Erst dann merge

---

*"8/8 oder nichts."*
