# CSC 6304 — Advanced Programming Concepts
## Final Exam — Spring 2026

**Available:** Tuesday at 8:00 PM EST  
**Window:** 4 hours from when you begin  
**Hard deadline:** This Saturday at 11:59 PM EST  
**Weight:** 25% of your overall course grade  
**Policy:** Open book, open notes — no general internet search permitted

---

#Instructions
## Pay close attention to instructions here as well as per question as this exam will be graded more rigorously than other projects.  

### Setup
- Create a Local Repository
Create a local repository on your system and add this FINAL-EXAM.md file to your repository.  All of your essay answers will be added to the FINAL-EXAM.md file. Any code submitted will also be included in this repository (Questions 4 and 5) 

- Create a GitLab repository
Create a final-exam repository in GitLab.  This MUST!!! be under your group that was created for you at the beginning of the semester.  CSC6304/2026/spring/YOUR-NAME.  If your repository is not here I will not have access and you will be graded with a Zero.


### How to Submit

In Canvas... Submit your Repository URL and your Live Website URL in Canvas (Make sure link is clickable! 10pt deduction if link is not navigable from canvas):

- All written answers should be added below the '**Answer:**' line for the corresponding questions.
- Include your code and .yml files in your repository.
- For questions 4 and 5, you may make as many commits as you like, however, your final commit for each question should be "Final-Commit Question 4" for question 4 and "Final-Commit for Question 5" as the commit message.  
---

## Questions 1–3 — Written Short Paragraph (Week 1, 2, 3)

*Each answer should be a short paragraph. Demonstrate understanding — do not simply define terms.*

---

### Question 1 — Week 1: Software Development Lifecycle & Methodologies

Git - Version Control

Describe a basic Git workflow for making changes to a project. In your answer, discuss the different trees/areas that Git uses to track files, the commands that move code between each area, and provide a step-by-step example of how you would make and commit changes to a repository.

Your response should include:

- The three main areas where files can exist in Git
- At least 5 Git commands and what they do

 **Answer:**


---

### Question 2 — Week 2: Networking Fundamentals

**Topic: OSI Model (Layers 4 & 7)**
Compare the responsibilities of **Layer 4 (Transport Layer)** and **Layer 7 (Application Layer)**. Explain why a load balancer operating at Layer 7 can make routing decisions based on a URL path or a cookie, whereas a Layer 4 load balancer can only route based on IP addresses and ports.


 **Answer:**


---

### Question 3 — Week 3: APIs

Compare **REST** and **GraphQL** as API paradigms. Describe a scenario where GraphQL's approach to data fetching solves a genuine problem that REST struggles with, and a scenario where REST's simplicity and cacheability make it the better architectural choice. In your answer, explain the terms *over-fetching* and *under-fetching* and how GraphQL addresses them.

 **Answer:**

 

---

## Questions 4 & 5 — Practical Coding (Week 4: HTML, CSS & JavaScript)

Questions 4 and 5 use the **same GitLab repository**, submitted as **two separate commits**. You will paste both commit URLs into this document.


---

### Question 4 — Week 4, Part A: Semantic HTML & CSS

**Task:** Build a single HTML page that displays three boxes nested inside each other. Each box must have a distinct background color and a visible border. There must be no JavaScript on this page — only HTML and a linked external CSS stylesheet.

**Requirements:**

- The file must be named `index.html`.
- The stylesheet must be in a separate file named `styles.css` and linked from `index.html` using a `<link>` tag — no `<style>` blocks, no inline `style=""` attributes.
- Use **semantic HTML** — the page must include a `<header>`, `<main>`, and the three boxes must be wrapped in a `<section>` or `<article>` element. Use structurally meaningful tags rather than a chain of plain `<div>` elements.
- The three boxes must be genuinely nested: the second box is visually inside the first, and the third box is visually inside the second.
- Each box must have:
  - A unique background color (your choice of colors)
  - A visible border with a style of your choice (solid, dashed, dotted, etc.)
  - Sufficient padding so that the inner box does not touch the edges of the outer box
- The page must be valid HTML — include a proper `<!DOCTYPE html>` declaration, `<html lang="en">`, `<head>` with `<meta charset>` and a `<title>`.
- The page must render correctly when opened directly in a browser from the local file system (no server required).

**You may have as many commits as you like.** The commit message for the commit that will be graded should contain:
```Final-Commit Question #4``` 






---

### Question 5 — Week 4, Part B: Adding JavaScript

**Task:** Add a JavaScript file to the same repository that makes the boxes interactive. Do **not** modify `index.html` or `styles.css` from Question 4 — add only a new file.

**Requirements:**

- Add a new file named `app.js` to the repository.
- Link `app.js` from `index.html` using a <script></script> tag added to the `<body>`. This is the **only permitted modification** to `index.html`.
- Add a `<button>` element to the `index.html` page with the text **"Randomize Colors"**. The button may be placed anywhere visually logical (e.g., inside `<main>`, above or below the nested boxes).
- In `app.js`, write JavaScript that:
  - Selects all three box elements from the DOM
  - When the **"Randomize Colors"** button is clicked, assigns a new random background color to each box independently
  - Each click must produce a different color for each box — no two boxes should receive the same color in a single click (each click picks 3 distinct random colors)
  - Colors must be generated programmatically in JavaScript — no hardcoded color arrays
- There must be NO inline event handlers (`onclick=""`) in HTML — all event wiring must happen in `app.js`.
- The button and color randomization must work when the page is opened directly in a browser from the local file system.

**You may have as many commits as you like.** The commit message for the commit that will be graded should contain:
```Final-Commit Question #4``` 

---

## Questions 6–8 — Written Short Paragraph (Week 6,7,8)

*Each answer should be a short paragraph. Demonstrate understanding — do not simply define terms.*

---

### Question 6 — Week 6: Native Mobile Development

Compare the approach to **state management and UI updates** in native mobile development (such as Jetpack Compose or SwiftUI) versus traditional imperative UI programming. Explain how a **declarative UI** framework handles changes to the application state, and why this approach reduces the likelihood of "out-of-sync" UI bugs. In your answer, describe the general process of how a change in data triggers a visual update on the device.

 **Answer:**


---

### Question 7 — Weeks 6 & 7: Native vs. Hybrid Mobile Development

Explain the architectural difference between **React Native** and **Flutter** as hybrid mobile development frameworks. Your answer should address how each framework renders UI — specifically, what React Native's `<View>` component becomes on iOS versus what Flutter draws on screen. Given this difference, why would a team choose Flutter for a product that requires pixel-perfect visual consistency across iOS, Android, and the web?

 **Answer:**


---

### Question 8 — Week 8: Development Approaches & AI-Assisted Development

Compare the three major technical construction approaches: **Built-In Commands**, **Assembly Development**, and **Assisted Development**. In your answer, describe one primary advantage and one primary risk associated with using "Built-In Commands" (writing from scratch) versus "Assembly Development" (using libraries). Why is the "Built-In" phase considered essential for the learning and growth of developers who later use AI tools?

 **Answer:**



---

## Grading Rubric

| # | Topic | Type | Points |
|---|-------|------|--------|
| Q1 | Week 1 — SDLC & Methodologies | Written paragraph | 10 |
| Q2 | Week 2 — Networking & TLS | Written paragraph | 10 |
| Q3 | Week 3 — APIs | Written paragraph | 10 |
| Q4 | Week 4 — Semantic HTML & CSS | Code — GitLab commit | 20 |
| Q5 | Week 4 — JavaScript interactivity | Code — GitLab commit | 20 |
| Q6 | Week 6 — Native Mobile Development | Written paragraph | 10 |
| Q7 | Weeks 6 & 7 — Native vs. Hybrid | Written paragraph | 10 |
| Q8 | Week 8 — AI-Assisted Development | Written paragraph | 10 |
| **Total** | | | **100** |

### Written Answer Rubric (per question, 10 points)

| Score | Criteria |
|-------|----------|
| 9–10 | Answer is accurate, specific, and demonstrates applied understanding. Uses correct terminology. Connects concepts to real consequences or trade-offs. |
| 7–8 | Answer is mostly accurate with minor gaps. Shows understanding of the concept but may lack specificity or a concrete example. |
| 5–6 | Answer is partially correct. Demonstrates surface-level familiarity but misses key nuance or conflates terms. |
| 3–4 | Answer attempts the question but contains significant inaccuracies or misses the core concept. |
| 0–2 | Answer is missing, off-topic, or demonstrates no understanding of the material. |

### Question 4 Code Rubric (20 points)

| Criteria | Points |
|----------|--------|
| Valid HTML structure (`<!DOCTYPE>`, `<html lang>`, `<head>`, `<body>`, `<title>`, `<meta charset>`) | 3 |
| Semantic elements used (`<header>`, `<main>`, `<section>` or `<article>` for boxes) | 3 |
| CSS is in a separate `styles.css` file — no inline styles, no `<style>` block | 4 |
| Three boxes are genuinely nested (visually inside each other) | 4 |
| Each box has a distinct background color and visible border | 3 |
| Adequate padding so inner boxes do not touch outer box edges | 3 |

### Question 5 Code Rubric (20 points)

| Criteria | Points |
|----------|--------|
| `app.js` is a separate file linked with `<script defer>` | 3 |
| Button is present in HTML with "Randomize Colors" text | 2 |
| Event listener wired in `app.js` — no inline `onclick` in HTML | 3 |
| All three boxes receive a new background color on click | 4 |
| Colors are generated programmatically — no hardcoded color arrays | 4 |
| Each box receives a distinct color per click (no two boxes same color) | 4 |

---

*Good luck. It has been a pleasure teaching this course.*  
*— Professor Robert Sand*
