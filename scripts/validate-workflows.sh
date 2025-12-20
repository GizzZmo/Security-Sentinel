#!/bin/bash

# Workflow Validation Script
# Validates all GitHub Actions workflow files for syntax and best practices

set -e

echo "🔍 GitHub Actions Workflow Validation"
echo "======================================"
echo ""

WORKFLOW_DIR=".github/workflows"
ERRORS=0
WARNINGS=0

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check YAML syntax
check_yaml_syntax() {
    local file=$1
    echo -n "Checking YAML syntax: $(basename $file)... "
    
    if python3 -c "import yaml; yaml.safe_load(open('$file'))" 2>/dev/null; then
        echo -e "${GREEN}✓${NC}"
        return 0
    else
        echo -e "${RED}✗${NC}"
        ((ERRORS++))
        return 1
    fi
}

# Function to check workflow name
check_workflow_name() {
    local file=$1
    local name=$(grep "^name:" "$file" | head -1)
    
    if [ -z "$name" ]; then
        echo -e "${YELLOW}⚠${NC} Warning: No workflow name in $(basename $file)"
        ((WARNINGS++))
        return 1
    fi
    return 0
}

# Function to check for required fields
check_required_fields() {
    local file=$1
    local has_on=$(grep "^on:" "$file")
    local has_jobs=$(grep "^jobs:" "$file")
    
    if [ -z "$has_on" ]; then
        echo -e "${RED}✗${NC} Error: Missing 'on:' trigger in $(basename $file)"
        ((ERRORS++))
        return 1
    fi
    
    if [ -z "$has_jobs" ]; then
        echo -e "${RED}✗${NC} Error: Missing 'jobs:' in $(basename $file)"
        ((ERRORS++))
        return 1
    fi
    
    return 0
}

# Function to check action versions
check_action_versions() {
    local file=$1
    
    # Check for unpinned actions (using @main or @master)
    if grep -q "uses:.*@\(main\|master\)" "$file"; then
        echo -e "${YELLOW}⚠${NC} Warning: Unpinned action version in $(basename $file)"
        ((WARNINGS++))
    fi
}

# Function to check for secrets
check_secrets() {
    local file=$1
    
    # Check if secrets are used but not documented
    if grep -q "secrets\." "$file"; then
        echo "  ℹ️  Secrets used in $(basename $file)"
    fi
}

# Main validation loop
echo "🔍 Validating workflows in $WORKFLOW_DIR"
echo ""

for workflow in "$WORKFLOW_DIR"/*.yml; do
    if [ -f "$workflow" ]; then
        echo "📄 Validating: $(basename $workflow)"
        echo "----------------------------------------"
        
        check_yaml_syntax "$workflow"
        check_workflow_name "$workflow"
        check_required_fields "$workflow"
        check_action_versions "$workflow"
        check_secrets "$workflow"
        
        echo ""
    fi
done

# Summary
echo "======================================"
echo "📊 Validation Summary"
echo "======================================"
echo -e "Total workflows checked: $(ls -1 $WORKFLOW_DIR/*.yml | wc -l)"
echo -e "${RED}Errors: $ERRORS${NC}"
echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
echo ""

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ All workflows passed validation!${NC}"
    exit 0
else
    echo -e "${RED}❌ Validation failed with $ERRORS error(s)${NC}"
    exit 1
fi
