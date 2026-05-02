# CalmFalcon Product Overview

**Your complete guide to the CalmFalcon product**

---

## What is CalmFalcon?
AI Signals Intelligence Platform for AI Platform Leaders
Calmfalcon solves the problem of fragmented, noisy AI ecosystem monitoring by transforming multi-source signals into structured, confidence-scored intelligence themes that supports faster decision making.


### Core Value Proposition
AI platform/infrastructure leaders waste significant time and still miss critical ecosystem shifts because signals are fragmented across GitHub, arXiv, vendor release notes, Top AI Newsletter(public). A scored, clustered, citation-backed “signal intelligence” experience will reduce monitoring or research time and improve decision confidence.

The AI Infrastructure ecosystem is moving faster than humans can track. The cost of being late is high.

---

## Product Philosophy

### Key Principles

**1. AI augments product leaders and engineering managers, never replaces them**
- AI Platform Leaders and engineering managers make final decisions
- AI handles tedious extraction and analysis
- Human expertise + machine speed = better outcomes
- Confidence scores on everything

**2. Accuracy is non-negotiable**
- 95%+ accuracy or we don't ship
- Clear "AI Confidence Score" tags
- Clear "Signal Tier - ACT (act this week) or WATCH (track over 30 days)" tags
- Validated on thousands of AI Signals
- Transparency on model limitations

**3. Security is table stakes**
- SOC 2 Type II certified
- Data encryption at rest and in transit
- Zero-retention policy option

**4. Speed unlocks value**
- Dashboard should be super fast to use

---

## Core Features

### 1. Themes Dashboard

**What users can do:**
- View Theme cards with clear summary, confidence score, type of signal
- Click on the card and see "Why it Matters", "What you can do", "Supporting Signals"
- View Weekly Brief
- Download Weekly Brief
- Track Delta Week over Week

**Our differentiation:**
- **Intelligence of clustering, scoring, classifying and synthesizing the data available:** 95%+ accuracy on themes available
- **Save users 4+ hours every week which is way better than just summarization platforms as there is no synthesis of data available from different resources in those platforms**

**Technical details:**
- Supports: PDF, DOCX, DOC, images (JPG, PNG)
- Max batch size: 10000+ signals

### 2. Weekly AI Breifs
--

## Product Roadmap (Simplified)

### Already Shipped (Current Product)

### In Progress (Q1 2026)
- MVP is Multi-Agent Flow in n8n for Backend and V0 for Front End integrated and deployed for demo day on March 28th
- Evaluations also need to be built in n8n
- Sources:  Top 50 Github Repos for the week for velocity and stars, AI Papers from 1-2 relaiable sources, Top 20 Vendor Official Docs and Release Pages, Top 20 Public AI Public Newsletters on Substack, Linkedin and X.com

### Planned (Q2-Q3 2026)

### Research Phase (Exploring)

---

## Product Metrics

### North Star Metric

**Number of correct themes found Per Week** - Number of correct themes processed through calmFalcon
**Hours saved Per Week** - Number of hours saved with calmFalcon
**Number of Active Users** - Users who are actively logging in and engaging with themes by clicking on it or downloading weekly briefs


**Why this metric?**
- Indicates actual usage (not just logins)
- Measures value delivery (time saved)
- Leading indicator of retention
- Correlates with revenue (more correct signals = higher value)

**Current:** 0
**Goal (Q2 2026):** 500 - 1000

---

### Product Health Metrics

**Activation:**
- **Definition:** User reviews first theme/signal within 7 days of signup
- **Current:** 
- **Target:** 
- **Why it matters:** Activated users are 8x more likely to become paying customers

**AI Accuracy:**
- **Definition:** Theme/signal clustering precision (% of clustered themes that are correct)
- **Current:** 
- **Target:** 
- **Why it matters:** Accuracy drives trust, trust drives adoption

**Time Saved Per Week:**
- **Definition:** Manual review time minus calmFalcon review time
- **Current:** 3.5 hours saved per signal/theme
- **Target:** 4+ hours
- **Why it matters:** Time saved = ROI = retention

**Retention:**
- **Definition:** % of customers active in month N who are active in month N+12
- **Current:** 
- **Target:** 
- **Why it matters:** Retention drives LTV and revenue growth

---

## Pricing & Packaging

### Current Plans

**Starter Plan ($0 for week):**

**Professional Plan ($39/month):**

**Enterprise Plan (TBD):**
- Unlimited users

### Competitive Pricing

**Our strategy:** 

---

## Technology Stack

**Frontend:**
- React + TypeScript
- Tailwind CSS
- React Query (data fetching)
- WebSockets (real-time collaboration)

**Backend:**
- Python + FastAPI
- PostgreSQL (primary database)
- Redis (caching, job queues)
- S3 (signal storage, encrypted)
- Elasticsearch (full-text search)
- Supabase for Vector DB if needed

**AI/ML:**
- GPT-5.4 and Claude Opus
- Continuous learning from user feedback

**Infrastructure:**
- GCP (hosting: US Central, US West)
- Docker + Kubernetes
- Terraform (infrastructure as code)

**Security:**
- SOC 2 Type II certified
- GDPR and CCPA compliant
- AES-256 encryption (at rest and in transit)
- SSO (SAML, OAuth)
- Role-based access control (RBAC)
- Audit logs (immutable)


---

## Product Documentation

All product documentation lives in:
- **Notion:** Product specs, PRDs, research, roadmap
- **Figma:** Designs, mockups, design system
- **GitHub:** Technical specs, API docs, ML model docs

## Tools
- V0 for Front End 
- n8n for Backend
---

*