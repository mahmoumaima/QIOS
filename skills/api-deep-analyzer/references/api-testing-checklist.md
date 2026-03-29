# API Testing Checklist — api-deep-analyzer
# (Local copy — source of truth: ../../_shared/api-testing-checklist.md)

See full checklist at: `../../_shared/api-testing-checklist.md`

## Quick Reference

### Always test
- [ ] Happy path with valid complete data
- [ ] Each required field missing independently
- [ ] No auth token → 401
- [ ] Invalid/expired token → 401
- [ ] Wrong role → 403
- [ ] Boundary: min value accepted, min-1 rejected
- [ ] Boundary: max value accepted, max+1 rejected
- [ ] Null vs empty string vs missing field
- [ ] SQL injection in string fields
- [ ] IDOR: another user's resource with own token

### For financial endpoints, also test
- [ ] Negative amount rejected
- [ ] Zero amount behavior defined
- [ ] Decimal precision correct
- [ ] Duplicate request / idempotency
- [ ] Rollback on partial failure
