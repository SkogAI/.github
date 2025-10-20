# Claude Workflow Manager - Usage Examples

## Example 1: Creating a Feature Issue

**You comment:**
```
@claude create an issue for adding Docker support

We need to containerize the application with:
- Multi-stage build for smaller image size
- Development and production configurations
- Docker Compose setup for local development
- Health checks
```

**Claude responds:**
```
I've created issue #145: Add Docker containerization support

📋 Issue details:
- Labels: enhancement, infrastructure
- Includes acceptance criteria checklist
- Added context about multi-stage builds
- Linked to #132 (deployment automation)

🔗 https://github.com/yourorg/yourrepo/issues/145

Next steps I recommend:
1. Create #146 for CI/CD integration with Docker
2. Update #132 to depend on this issue
```

**The created issue looks like:**
```markdown
## Description
Add Docker containerization support to enable consistent development and deployment environments.

## Context
This will standardize the deployment process and make it easier for new developers to get started.

## Acceptance Criteria
- [ ] Create Dockerfile with multi-stage build
- [ ] Reduce final image size below 200MB
- [ ] Add docker-compose.yml for local development
- [ ] Add docker-compose.prod.yml for production
- [ ] Include health check endpoints
- [ ] Update README with Docker setup instructions
- [ ] Add .dockerignore file

## Implementation Notes
- Use Alpine Linux base for smaller image size
- Separate dev dependencies from production
- Include environment variable documentation

## Related
- Related to #132 (deployment automation)

## Labels
enhancement, infrastructure, docker
```

---

## Example 2: Breaking Down Large Issues

**You comment on issue #150:**
```
@claude this issue is too big. Can you break it down into smaller, manageable tasks?
```

**Claude analyzes #150 and responds:**
```
I've broken down #150 into 5 focused issues:

✅ Created issues:
- #151: Database schema design (2-3 days)
- #152: API endpoint implementation (3-4 days)
- #153: Frontend UI components (4-5 days)
- #154: Authentication integration (2 days)
- #155: End-to-end testing (2 days)

All issues are linked with "blocks" relationships:
#151 → #152 → #154 → #153 → #155

I've also updated #150 to be a tracking issue with checkboxes for each subtask.

Total estimated time: 13-16 days
```

---

## Example 3: Workflow Planning

**You comment:**
```
@claude what needs to happen before we can release v2.0?
```

**Claude responds:**
```
Analyzing the v2.0 milestone...

🚧 Blocking issues (must complete):
- #145 Docker support (in progress)
- #167 Migration script (not started)
- #178 Breaking changes documentation (not started)

⚠️ High priority issues (should complete):
- #156 Performance optimization (in progress)
- #189 Security audit (in review)

📋 Nice to have (defer if needed):
- #134 Dark mode UI
- #192 Advanced analytics

Suggested action plan:
1. I'll create #201 for the migration script (blocks v2.0)
2. I'll create #202 for breaking changes docs (blocks v2.0)
3. Consider creating a release checklist issue?

Should I proceed with creating these issues?
```

---

## Example 4: Bug Tracking

**You comment:**
```
@claude create a bug issue for the login timeout problem users are reporting

Error message: "Session expired" after 5 minutes
Expected: 30 minute timeout
Priority: high
```

**Claude creates:**
```markdown
## Description
Users are experiencing premature session timeouts, getting "Session expired" errors after only 5 minutes of activity.

## Expected Behavior
- Session timeout should be 30 minutes
- Activity should reset the timeout timer

## Actual Behavior
- Session expires after ~5 minutes
- Error message: "Session expired"
- Forces users to re-authenticate frequently

## Reproduction Steps
1. Log in to the application
2. Wait 5-6 minutes with minimal activity
3. Attempt any action
4. Observe "Session expired" error

## Environment
- Reported across multiple users
- Affects all browsers

## Possible Cause
- Incorrect session configuration in auth middleware
- Token expiration mismatch between frontend and backend

## Labels
bug, priority-high, user-experience, authentication

## Related Issues
- May be related to #134 (auth refactor)
```

---

## Example 5: Dependency Management

**You comment:**
```
@claude what issues are blocked and what are they waiting for?
```

**Claude responds:**
```
📊 Dependency Analysis:

🔒 Blocked Issues (5):
1. #156 API optimization
   ↳ Blocked by: #145 Docker support

2. #167 Load testing
   ↳ Blocked by: #156 API optimization
   ↳ Blocked by: #145 Docker support

3. #178 Documentation
   ↳ Blocked by: #145 Docker support
   ↳ Blocked by: #167 Migration script

4. #201 CI/CD pipeline
   ↳ Blocked by: #145 Docker support

5. #189 Security audit
   ↳ Blocked by: #156 API optimization

🎯 Critical path: #145 → #156 → #167 → #178

💡 Recommendation:
Completing #145 will unblock 4 other issues. Should I:
1. Check its current status?
2. See if we can help move it forward?
3. Create a reminder to check dependencies in 2 days?
```

---

## Example 6: PR Review Integration

**You comment on a PR:**
```
@claude review this PR and create follow-up issues for any improvements
```

**Claude responds:**
```
PR Review Summary:

✅ Looks good:
- Code quality is solid
- Tests are comprehensive
- No security concerns

🔧 Created follow-up issues:
- #210: Extract magic numbers to constants (minor refactor)
- #211: Add integration tests for edge cases (testing)
- #212: Update API documentation for new endpoints (docs)

These are marked as "tech-debt" and linked to this PR for context.

The PR is ready to merge! The follow-up issues can be tackled in future sprints.
```

---

## Example 7: Sprint Planning

**You comment:**
```
@claude create a sprint planning issue for the next 2-week sprint

Focus areas:
- Performance improvements
- Bug fixes
- Docker migration

Team capacity: 3 developers
```

**Claude creates:**
```markdown
## Sprint Goals (2 weeks)

### Primary Objectives
1. 🚀 Performance improvements
2. 🐛 Critical bug fixes
3. 🐳 Docker migration completion

### Team Capacity
- 3 developers
- 10 working days
- ~30 dev-days total

### Proposed Sprint Backlog

#### High Priority (Must Complete)
- [ ] #145 Docker support (8 days) - @assigned
- [ ] #198 Login timeout bug (2 days)
- [ ] #203 Database query optimization (4 days)

Subtotal: 14 dev-days

#### Medium Priority (Should Complete)
- [ ] #156 API optimization (4 days)
- [ ] #167 Migration script (3 days)
- [ ] #204 Memory leak fix (2 days)

Subtotal: 9 dev-days

#### Buffer (If Time Permits)
- [ ] #134 Dark mode UI (5 days)
- [ ] #192 Analytics dashboard (8 days)

### Risk Assessment
⚠️ Docker support is complex - may need buffer time
✅ Bug fixes are well-scoped
💡 Consider pairing on Docker work

### Dependencies
- #145 must complete before #167
- #203 should complete before #156

### Definition of Done
- All code reviewed and merged
- Tests passing at >80% coverage
- Documentation updated
- Deployed to staging for QA

---
**Sprint Timeline**: Oct 15 - Oct 28
**Daily Standup**: 9:30 AM
**Sprint Review**: Oct 28 at 2 PM
```

---

## Pro Tips

1. **Be specific with requirements** - Claude creates better issues with clear criteria
2. **Use labels/priorities in requests** - Claude will apply them to issues
3. **Mention related work** - Claude will link issues automatically
4. **Ask for breakdowns** - Claude excels at decomposing complex tasks
5. **Request dependency analysis** - Claude can map out issue relationships
6. **Iterate** - You can ask Claude to refine or modify issues after creation

## Common Workflows

### Starting a new feature
```
@claude create a feature implementation plan for [FEATURE] with subtasks
```

### Release preparation
```
@claude what's blocking the v[X.Y] release?
```

### Technical debt
```
@claude analyze issues labeled 'tech-debt' and prioritize them
```

### Bug triage
```
@claude create a bug triage checklist for the issues from this week
```
