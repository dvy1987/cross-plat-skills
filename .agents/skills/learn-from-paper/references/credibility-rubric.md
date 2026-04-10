# Paper Credibility Rubric

Read this at Step 2 before scoring any paper. Score each dimension 0/1/2. Gate: total must be ≥7/12 to proceed.

---

## Dimensions

### 1. Author Reputation (0–2)
- **2**: Authors have published 3+ papers in the domain. Affiliated with a recognized research institution (university, named AI lab, major tech company research division). Identifiable via Google Scholar or DBLP.
- **1**: Authors identifiable but limited track record in this specific domain. Institution is legitimate but not prominent in this field.
- **0**: Authors unidentifiable, pseudonymous, or affiliated with a known paper mill. No verifiable publication history.

### 2. Venue Quality (0–2)
- **2**: Published in a top-tier peer-reviewed venue (NeurIPS, ICML, ICLR, ACL, EMNLP, CVPR, Nature, Science, JMLR) or an official technical report from Anthropic, OpenAI, Google DeepMind, Meta AI Research with methodology section.
- **1**: arXiv preprint with 50+ citations OR from a named lab AND less than 18 months old. Workshop papers at top venues. Named engineering blogs (Vercel, Stripe, Linear, Shopify).
- **0**: Unpublished, self-hosted, no venue, predatory journal (check Beall's List), or anonymous blog post.

### 3. Methodology Rigor (0–2)
- **2**: Clear experimental design. Defined baselines and comparisons. Statistical significance reported. Sufficient sample size. Reproducibility information provided (code, data, hyperparameters).
- **1**: Methodology described but incomplete. Missing some baselines or significance tests. Limited sample but reasonable for the claim scope.
- **0**: No methodology section. Anecdotal evidence only. Cherry-picked examples. Claims not supported by described experiments.

### 4. Reproducibility (0–2)
- **2**: Code and data publicly available. Experiments can be independently verified. Results have been replicated by at least one other group.
- **1**: Methodology described in enough detail to attempt replication. Code or data partially available.
- **0**: No reproducibility information. Proprietary data with no description. "Trust us" claims.

### 5. Recency (0–2)
- **2**: Published within the recency window for its topic (see table below). Findings account for current model capabilities.
- **1**: Slightly outside recency window but core findings are likely still valid. No contradicting newer work found.
- **0**: Outside recency window AND newer work contradicts or supersedes the findings.

**Recency windows:**
| Topic | Window |
|-------|--------|
| Prompting techniques | 12 months |
| Model capabilities/limits | 6 months |
| Tool use / function calling | 6 months |
| Agent architectures | 18 months |
| Software engineering practices | 36 months |
| Skill/agent design patterns | 18 months |

### 6. Citation Network (0–2)
- **2**: 50+ citations. Cited by other High Trust sources. Part of an active research thread with follow-up work.
- **1**: 10–49 citations. Or: <10 citations but published within last 6 months from a recognized lab.
- **0**: 0–9 citations AND older than 6 months. Or: citations are predominantly self-citations or from the same group.

---

## Scoring

| Total | Verdict | Action |
|-------|---------|--------|
| 10–12 | **HIGH CONFIDENCE** | Apply findings fully. Cite as High Trust. |
| 7–9 | **PASS (MODERATE)** | Apply findings conservatively. Note limitations. |
| 4–6 | **BORDERLINE** | Do NOT apply. Present findings to user as informational only. |
| 0–3 | **REJECT** | Stop. Tell user why. Do not extract insights. |

---

## Quick Reject Criteria (any one = immediate REJECT)

- No identifiable authors
- Known predatory publisher (check Beall's List or equivalent)
- Core claims directly contradicted by a High Trust source without acknowledgment
- Paper is a literature review with no original findings (useful for references, not for skill application)
- Paper's methodology section is absent or describes only qualitative impressions
- Retracted paper (check Retraction Watch database)

---

## Borderline Handling

For papers scoring 7–8/12:
1. Warn user: "Borderline credibility — applying conservatively"
2. Only extract GOTCHAs and FAILURE_MODEs (highest-value, lowest-risk)
3. Do NOT apply TECHNIQUEs that would restructure a skill's workflow
4. Always add a caveat citation: "Source: [paper] (borderline credibility — verify independently)"
