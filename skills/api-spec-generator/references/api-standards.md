# API Collection Standards
# QIOS — api-spec-generator

---

## Collection Naming

```
QIOS — [Module] API Collection

Examples:
  QIOS — Wallet API Collection
  QIOS — Authentication API Collection
  QIOS — Orders API Collection
```

## Request Naming

```
[METHOD] [path] — [scenario]

Examples:
  POST /wallet/cashout — Happy Path
  POST /wallet/cashout — Missing amount (negative)
  GET  /users/{id}     — Non-existent user (negative)
  DELETE /orders/{id}  — No auth token (negative)
```

---

## Environment Variables

Always use variables — never hardcode values in requests.

| Variable | Description | Default |
|---|---|---|
| `{{base_url}}` | Base API URL | `https://api.dev.com` |
| `{{token}}` | Standard user Bearer token | empty |
| `{{admin_token}}` | Admin-level Bearer token | empty |
| `{{user_id}}` | Test user ID reference | empty |

---

## Request Organization

Group requests by resource, then by scenario:

```
Collection/
├── Authentication/
│   ├── POST /auth/login — Happy Path
│   ├── POST /auth/login — Wrong password
│   └── POST /auth/logout — Valid token
├── Wallet/
│   ├── POST /wallet/cashout — Happy Path
│   ├── POST /wallet/cashout — Missing amount
│   └── POST /wallet/cashout — No auth
└── Orders/
    └── ...
```

---

## Mandatory Assertions (every request)

```javascript
// 1. Status code
pm.test("Status code is correct", function() {
  pm.response.to.have.status(expectedCode);
});

// 2. Response time
pm.test("Response time < 2000ms", function() {
  pm.expect(pm.response.responseTime).to.be.below(2000);
});

// 3. Content-Type
pm.test("Content-Type is JSON", function() {
  pm.expect(pm.response.headers.get("Content-Type")).to.include("application/json");
});
```

## Optional Assertions (add when relevant)

```javascript
// Body field presence
pm.test("Has [field]", function() {
  const body = pm.response.json();
  pm.expect(body).to.have.property("[field]");
});

// Field type
pm.test("[field] is a string", function() {
  const body = pm.response.json();
  pm.expect(body.[field]).to.be.a("string");
});

// Error message
pm.test("Error message present", function() {
  const body = pm.response.json();
  pm.expect(body).to.have.property("error");
  pm.expect(body.error).to.not.be.empty;
});
```
