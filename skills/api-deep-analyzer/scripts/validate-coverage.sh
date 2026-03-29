#!/bin/bash
# validate-coverage.sh
# QIOS — api-deep-analyzer
#
# Usage: bash validate-coverage.sh [test-cases-file.md]
# Checks whether a test case file covers all required QIOS categories.

FILE=${1:-"output-test-cases.md"}

if [ ! -f "$FILE" ]; then
  echo "❌ File not found: $FILE"
  echo "Usage: bash validate-coverage.sh [path-to-test-cases.md]"
  exit 1
fi

echo ""
echo "🔍 QIOS Coverage Validator"
echo "   File: $FILE"
echo "──────────────────────────────────────────"

PASS=0
FAIL=0

check() {
  local label="$1"
  local pattern="$2"
  if grep -qi "$pattern" "$FILE"; then
    echo "  ✅  $label"
    PASS=$((PASS + 1))
  else
    echo "  ❌  MISSING — $label"
    FAIL=$((FAIL + 1))
  fi
}

echo ""
echo "  📋 Test Categories"
check "Happy Path"             "happy path"
check "Negative Cases"        "negative"
check "Boundary Cases"        "boundary"
check "Edge Cases"            "edge"
check "Security Cases"        "security"

echo ""
echo "  🔒 Security Checks"
check "Auth — no token"       "401\|no.*token\|missing.*auth"
check "Auth — invalid token"  "invalid.*token\|expired.*token"
check "Auth — wrong role"     "403\|wrong.*role\|forbidden"
check "SQL Injection"         "sql.*inject\|OR.*1.*=.*1\|DROP TABLE"
check "IDOR"                  "idor\|another.*user\|user_b\|user_a"

echo ""
echo "  📊 Quality Checks"
check "Risk levels tagged"    "\[CRITICAL\]\|\[HIGH\]\|\[MEDIUM\]\|\[LOW\]"
check "Flags section"         "\[MISSING\]\|\[ASSUMPTION\]"
check "Expected results"      "expected"

echo ""
echo "──────────────────────────────────────────"
echo "  Results: $PASS passed / $FAIL missing"

if [ $FAIL -eq 0 ]; then
  echo "  🎉 Full coverage — ready to execute."
else
  echo "  ⚠️  Address missing items before shipping."
fi
echo ""
