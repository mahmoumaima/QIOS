---
name: api-spec-generator
description: >
  Generate a ready-to-import Postman or Bruno collection from an API spec,
  Swagger/OpenAPI file, or endpoint description. Use this skill whenever the
  user wants to create, export, or scaffold an API test collection. Triggers on:
  "generate Postman collection", "create Bruno spec", "import-ready collection",
  "generate collection from Swagger", "give me a Postman file", "Bruno collection
  for this API", "create API spec file", "export to Postman". Always prefer this
  skill over writing collections manually.
---

# API Spec Generator

## Purpose

Turn any API description into a structured, importable collection for Postman or Bruno —
with environment variables, auth, and test assertions pre-configured and ready to use.

---

## Input Accepted

- Swagger / OpenAPI spec (JSON or YAML)
- List of endpoints with methods and body descriptions
- Single endpoint with headers, body, and auth
- Existing collection to extend or update

---

## Output Options

Ask the user which format:
- **Postman** → Collection v2.1 JSON (import via File → Import in Postman)
- **Bruno** → `.bru` files + `bruno.json` manifest
- **Both** → generate both formats

---

## Generation Process

**Step 1** — Parse all endpoints: method, path, params, body schema, auth type.

**Step 2** — Define environment variables:
```
{{base_url}}      Base API URL
{{token}}         Bearer auth token
{{admin_token}}   Admin-level token (if needed)
{{user_id}}       Dynamic user reference
```

**Step 3** — For each endpoint generate:
- 1 happy path request (valid data, full headers)
- 1 negative case (missing required field or no auth)
- Pre-request script for Bearer auth
- Test assertions script

**Step 4** — Assertions template (per request):
```javascript
pm.test("Status code correct", () => pm.response.to.have.status(expectedCode));
pm.test("Response time < 2000ms", () => pm.expect(pm.response.responseTime).to.be.below(2000));
pm.test("Content-Type is JSON", () =>
  pm.expect(pm.response.headers.get("Content-Type")).to.include("application/json")
);
pm.test("Response body has expected field", () => {
  const body = pm.response.json();
  pm.expect(body).to.have.property("expected_field");
});
```

---

## References

- `references/api-standards.md` — Naming, organization, and assertion conventions
- `examples/input-swagger.json` — Example Swagger input
- `examples/output-postman.json` — Example Postman v2.1 output
- `examples/output-bruno/` — Example Bruno collection output
- `scripts/generate-collection.sh` — CLI scaffold script
