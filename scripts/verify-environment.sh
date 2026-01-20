#!/usr/bin/env bash

#===============================================================================
# Polyrepo Environment Verification Script
#
# This script verifies that a developer's local environment is correctly
# configured for working on the Polyrepo project.
#
# Usage: ./scripts/verify-environment.sh [OPTIONS]
#
# Options:
#   -i, --install       Automatically install missing dependencies without prompting
#   -s, --skip-install  Skip dependency installation prompts entirely
#   -p, --parallel      Run slow checks (network, compilation) in parallel
#   -S, --serial        Run all checks serially (no parallel execution)
#   -h, --help          Show this help message
#
#===============================================================================
# WHAT THIS SCRIPT CHECKS
#===============================================================================
#
# 1. REQUIRED TOOLS
#    - Java 21+ (for Spring Boot backend)
#    - Maven wrapper (mvnw) or system Maven
#    - Node.js 20+ (for React frontend)
#    - npm 9+ (package management)
#    - Docker 24+ (containerization)
#    - Docker Compose v2+ (local orchestration)
#    - Git (version control)
#
# 2. OPTIONAL TOOLS
#    - Okteto CLI (for preview environments)
#    - kubectl (for production deployments)
#    - AWS CLI (for EKS access)
#
# 3. SYSTEM RESOURCES
#    - Disk space: minimum 10GB available
#    - Docker memory: minimum 4GB allocated
#    - Docker CPUs: minimum 2 cores recommended
#
# 4. NETWORK CONNECTIVITY
#    - npm registry (registry.npmjs.org)
#    - Maven Central (repo.maven.apache.org)
#    - Docker Hub (registry-1.docker.io)
#    - Detects proxy configuration that may affect connectivity
#
# 5. DOCKER STATE
#    - Checks for stale polyrepo containers
#    - Identifies existing volumes (data persistence)
#    - Warns about dangling images wasting disk space
#
# 6. ENVIRONMENT VARIABLES
#    - OKTA_ISSUER_URI / OKTA_JWK_SET_URI (auth config)
#    - MONGODB_URI (database connection)
#    - OKTETO_TOKEN (preview deployments)
#    - HTTP_PROXY / HTTPS_PROXY (network proxy)
#
# 7. PROJECT SETUP & DEPENDENCIES
#    - Validates project directory structure
#    - Checks/installs root node_modules (npm install)
#    - Checks/installs frontend node_modules (npm install)
#    - Verifies frontend TypeScript compiles (tsc --noEmit)
#    - Checks Maven cache (~/.m2/repository)
#    - Verifies backend compiles (mvnw compile)
#    - Verifies husky git hooks are configured
#    - Offers to install/compile missing dependencies (interactive prompt)
#      Use --install to auto-install, --skip-install to skip prompts
#
# 8. PORT AVAILABILITY
#    - Port 3000 (Frontend dev server)
#    - Port 8080 (Backend API)
#    - Port 27017 (MongoDB)
#
#===============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0
WARNINGS=0

# Minimum versions
MIN_JAVA_VERSION=21
MIN_NODE_VERSION=20
MIN_NPM_VERSION=9
MIN_DOCKER_VERSION=24
MIN_DOCKER_COMPOSE_VERSION=2

# Resource requirements
MIN_DOCKER_MEMORY_GB=4
MIN_DISK_SPACE_GB=10
NETWORK_TIMEOUT=5

# Installation flags
AUTO_INSTALL=false
SKIP_INSTALL=false

# Parallel execution flags
PARALLEL_MODE=""  # "", "parallel", or "serial"

#===============================================================================
# Command Line Parsing
#===============================================================================

show_help() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════╗
║           POLYREPO ENVIRONMENT VERIFICATION - HELP                        ║
╚══════════════════════════════════════════════════════════════════════════╝

USAGE
    ./scripts/verify-environment.sh [OPTIONS]

DESCRIPTION
    Verifies that your local environment is correctly configured for
    Polyrepo development. Checks tools, dependencies, network connectivity,
    and optionally installs missing components.

OPTIONS
    -i, --install
        Automatically install missing dependencies without prompting.
        This will run:
          • npm install (root dependencies)
          • npm install (frontend dependencies)
          • mvnw compile (backend compilation & dependency download)
          • tsc --noEmit (frontend TypeScript verification)

    -s, --skip-install
        Skip all dependency installation prompts. Useful for quick checks
        or CI environments where you just want to verify status.

    -p, --parallel
        Run slow checks in parallel for faster execution:
          • Network connectivity (3 endpoints checked simultaneously)
          • Compilation (frontend & backend compiled in parallel)
        Saves approximately 30-60 seconds on full verification.

    -S, --serial
        Run all checks serially (one at a time). This is the default
        behavior if you decline parallel execution when prompted.
        Useful for debugging or when you need predictable output order.

    -h, --help
        Show this help message and exit.

WHAT THIS SCRIPT CHECKS
    1. Required Tools     - Java 21+, Node 20+, npm, Docker, Git
    2. Optional Tools     - Okteto CLI, kubectl, AWS CLI
    3. System Resources   - Disk space (10GB+), Docker memory (4GB+)
    4. Network            - npm registry, Maven Central, Docker Hub
    5. Docker State       - Existing containers, volumes, dangling images
    6. Environment Vars   - Okta, MongoDB, proxy configuration
    7. Project Setup      - Dependencies, compilation, husky hooks
    8. Port Availability  - 3000, 8080, 27017

EXAMPLES
    Interactive mode (prompts for each action):
        ./scripts/verify-environment.sh

    New developer setup (install everything automatically):
        ./scripts/verify-environment.sh --install

    Fast new developer setup (install everything in parallel):
        ./scripts/verify-environment.sh --install --parallel

    Quick status check (no installations):
        ./scripts/verify-environment.sh --skip-install

    Fast status check (parallel, no installations):
        ./scripts/verify-environment.sh --skip-install --parallel

    CI/CD pipeline (predictable, no prompts):
        ./scripts/verify-environment.sh --skip-install --serial

TEAM PROFILES
    When your environment passes all checks, you'll see a "Meet the Team"
    section. Add your profile by copying team/TEMPLATE.txt to team/your-name.txt
    and filling in your details (name, location, number of cats).

EXIT CODES
    0 - All checks passed (or passed with warnings)
    1 - One or more required checks failed

MORE INFORMATION
    See docs/SETUP_CHECKLIST.txt for complete setup instructions.
EOF
    exit 0
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -i|--install)
                AUTO_INSTALL=true
                shift
                ;;
            -s|--skip-install)
                SKIP_INSTALL=true
                shift
                ;;
            -p|--parallel)
                PARALLEL_MODE="parallel"
                shift
                ;;
            -S|--serial)
                PARALLEL_MODE="serial"
                shift
                ;;
            -h|--help)
                show_help
                ;;
            *)
                echo "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
}

#===============================================================================
# Helper Functions
#===============================================================================

prompt_yes_no() {
    local prompt="$1"
    local default="${2:-n}"

    if [ "$AUTO_INSTALL" = true ]; then
        return 0  # Yes
    fi

    if [ "$SKIP_INSTALL" = true ]; then
        return 1  # No
    fi

    local yn
    if [ "$default" = "y" ]; then
        read -r -p "  $prompt [Y/n]: " yn
        yn=${yn:-y}
    else
        read -r -p "  $prompt [y/N]: " yn
        yn=${yn:-n}
    fi

    case "$yn" in
        [Yy]* ) return 0 ;;
        * ) return 1 ;;
    esac
}

print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_check() {
    echo -e "  Checking $1..."
}

print_pass() {
    echo -e "  ${GREEN}✓${NC} $1"
    PASSED=$((PASSED + 1))
}

print_fail() {
    echo -e "  ${RED}✗${NC} $1"
    FAILED=$((FAILED + 1))
}

print_warn() {
    echo -e "  ${YELLOW}⚠${NC} $1"
    WARNINGS=$((WARNINGS + 1))
}

print_info() {
    echo -e "  ${BLUE}ℹ${NC} $1"
}

# Extract major version number from version string
extract_major_version() {
    echo "$1" | grep -oE '[0-9]+' | head -1
}

# Compare versions (returns 0 if $1 >= $2)
version_gte() {
    local version=$1
    local required=$2
    [ "$(printf '%s\n' "$required" "$version" | sort -V | head -n1)" = "$required" ]
}

#===============================================================================
# Check Functions
#===============================================================================

check_java() {
    print_check "Java"

    if ! command -v java &> /dev/null; then
        print_fail "Java is not installed"
        print_info "Install with: brew install openjdk@21"
        return
    fi

    local java_version_output=$(java -version 2>&1 | head -1)
    local java_version=$(echo "$java_version_output" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+|[0-9]+' | head -1)
    local java_major=$(extract_major_version "$java_version")

    if [ "$java_major" -ge "$MIN_JAVA_VERSION" ]; then
        print_pass "Java $java_version (required: $MIN_JAVA_VERSION+)"
    else
        print_fail "Java $java_version found, but version $MIN_JAVA_VERSION+ is required"
        print_info "Install with: brew install openjdk@21"
    fi

    # Check JAVA_HOME
    if [ -z "$JAVA_HOME" ]; then
        print_warn "JAVA_HOME is not set (may cause issues with some tools)"
    else
        print_info "JAVA_HOME: $JAVA_HOME"
    fi
}

check_maven() {
    print_check "Maven"

    # First check if mvnw exists in backend directory
    if [ -f "backend/mvnw" ]; then
        print_pass "Maven Wrapper (mvnw) found in backend/"

        # Check if it's executable
        if [ ! -x "backend/mvnw" ]; then
            print_warn "mvnw is not executable. Run: chmod +x backend/mvnw"
        fi
    else
        print_warn "Maven Wrapper not found in backend/"
    fi

    # Also check system Maven
    if command -v mvn &> /dev/null; then
        local mvn_version=$(mvn -version 2>&1 | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        print_info "System Maven: $mvn_version (optional, mvnw is preferred)"
    else
        print_info "System Maven not installed (not required, mvnw will be used)"
    fi
}

check_node() {
    print_check "Node.js"

    if ! command -v node &> /dev/null; then
        print_fail "Node.js is not installed"
        print_info "Install with: brew install node@20"
        return
    fi

    local node_version=$(node --version | tr -d 'v')
    local node_major=$(extract_major_version "$node_version")

    if [ "$node_major" -ge "$MIN_NODE_VERSION" ]; then
        print_pass "Node.js $node_version (required: $MIN_NODE_VERSION+)"
    else
        print_fail "Node.js $node_version found, but version $MIN_NODE_VERSION+ is required"
        print_info "Install with: brew install node@20"
    fi
}

check_npm() {
    print_check "npm"

    if ! command -v npm &> /dev/null; then
        print_fail "npm is not installed"
        return
    fi

    local npm_version=$(npm --version)
    local npm_major=$(extract_major_version "$npm_version")

    if [ "$npm_major" -ge "$MIN_NPM_VERSION" ]; then
        print_pass "npm $npm_version (required: $MIN_NPM_VERSION+)"
    else
        print_warn "npm $npm_version found, version $MIN_NPM_VERSION+ recommended"
        print_info "Update with: npm install -g npm@latest"
    fi
}

check_docker() {
    print_check "Docker"

    if ! command -v docker &> /dev/null; then
        print_fail "Docker is not installed"
        print_info "Install with: brew install --cask docker"
        return
    fi

    # Check if Docker daemon is running
    if ! docker info &> /dev/null; then
        print_fail "Docker is installed but the daemon is not running"
        print_info "Start Docker Desktop or run: open -a Docker"
        return
    fi

    local docker_version=$(docker --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    local docker_major=$(extract_major_version "$docker_version")

    if [ "$docker_major" -ge "$MIN_DOCKER_VERSION" ]; then
        print_pass "Docker $docker_version (required: $MIN_DOCKER_VERSION+)"
    else
        print_warn "Docker $docker_version found, version $MIN_DOCKER_VERSION+ recommended"
    fi
}

check_docker_compose() {
    print_check "Docker Compose"

    # Try docker compose (v2) first
    if docker compose version &> /dev/null; then
        local compose_version=$(docker compose version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        local compose_major=$(extract_major_version "$compose_version")

        if [ "$compose_major" -ge "$MIN_DOCKER_COMPOSE_VERSION" ]; then
            print_pass "Docker Compose $compose_version (required: $MIN_DOCKER_COMPOSE_VERSION+)"
        else
            print_warn "Docker Compose $compose_version found, version $MIN_DOCKER_COMPOSE_VERSION+ recommended"
        fi
        return
    fi

    # Fall back to docker-compose (v1)
    if command -v docker-compose &> /dev/null; then
        local compose_version=$(docker-compose --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        print_warn "docker-compose (v1) $compose_version found. Consider upgrading to Docker Compose v2"
        return
    fi

    print_fail "Docker Compose is not installed"
    print_info "Docker Compose v2 is included with Docker Desktop"
}

check_git() {
    print_check "Git"

    if ! command -v git &> /dev/null; then
        print_fail "Git is not installed"
        print_info "Install with: brew install git"
        return
    fi

    local git_version=$(git --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    print_pass "Git $git_version"

    # Check git configuration
    local git_user=$(git config --global user.name 2>/dev/null || echo "")
    local git_email=$(git config --global user.email 2>/dev/null || echo "")

    if [ -z "$git_user" ]; then
        print_warn "Git user.name is not configured"
        print_info "Set with: git config --global user.name \"Your Name\""
    fi

    if [ -z "$git_email" ]; then
        print_warn "Git user.email is not configured"
        print_info "Set with: git config --global user.email \"you@example.com\""
    fi
}

check_optional_tools() {
    print_check "Optional tools"

    # Okteto CLI
    if command -v okteto &> /dev/null; then
        local okteto_version=$(okteto version 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        print_pass "Okteto CLI $okteto_version"
    else
        print_info "Okteto CLI not installed (optional, for preview environments)"
        print_info "Install with: brew install okteto"
    fi

    # kubectl
    if command -v kubectl &> /dev/null; then
        local kubectl_version=$(kubectl version --client -o json 2>/dev/null | grep -oE '"gitVersion":\s*"v[0-9]+\.[0-9]+\.[0-9]+"' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        print_pass "kubectl $kubectl_version"
    else
        print_info "kubectl not installed (optional, for production deployments)"
        print_info "Install with: brew install kubectl"
    fi

    # AWS CLI
    if command -v aws &> /dev/null; then
        local aws_version=$(aws --version 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        print_pass "AWS CLI $aws_version"
    else
        print_info "AWS CLI not installed (optional, for EKS access)"
        print_info "Install with: brew install awscli"
    fi
}

install_root_dependencies() {
    echo ""
    echo -e "  ${BLUE}Installing root dependencies...${NC}"
    if npm install; then
        echo -e "  ${GREEN}✓${NC} Root dependencies installed successfully"
        return 0
    else
        echo -e "  ${RED}✗${NC} Failed to install root dependencies"
        return 1
    fi
}

install_frontend_dependencies() {
    echo ""
    echo -e "  ${BLUE}Installing frontend dependencies...${NC}"
    if (cd frontend && npm install); then
        echo -e "  ${GREEN}✓${NC} Frontend dependencies installed successfully"
        return 0
    else
        echo -e "  ${RED}✗${NC} Failed to install frontend dependencies"
        return 1
    fi
}

install_backend_dependencies() {
    echo ""
    echo -e "  ${BLUE}Compiling backend (this may take a few minutes on first run)...${NC}"
    if (cd backend && ./mvnw compile -B -q); then
        echo -e "  ${GREEN}✓${NC} Backend compiled successfully"
        return 0
    else
        echo -e "  ${RED}✗${NC} Backend compilation failed"
        return 1
    fi
}

compile_frontend_typescript() {
    echo ""
    echo -e "  ${BLUE}Type-checking frontend TypeScript...${NC}"
    if (cd frontend && npx tsc --noEmit 2>&1); then
        echo -e "  ${GREEN}✓${NC} Frontend TypeScript compilation successful"
        return 0
    else
        echo -e "  ${RED}✗${NC} Frontend TypeScript compilation failed"
        return 1
    fi
}

compile_all_parallel() {
    local do_frontend="$1"
    local do_backend="$2"

    echo ""
    echo -e "  ${BLUE}Running compilation checks in parallel...${NC}"

    local frontend_result_file=$(mktemp)
    local backend_result_file=$(mktemp)
    local pids=()

    # Start frontend compilation in background
    if [ "$do_frontend" = "true" ]; then
        (
            if (cd frontend && npx tsc --noEmit > /dev/null 2>&1); then
                echo "pass" > "$frontend_result_file"
            else
                echo "fail" > "$frontend_result_file"
            fi
        ) &
        pids+=($!)
    fi

    # Start backend compilation in background
    if [ "$do_backend" = "true" ]; then
        (
            if (cd backend && ./mvnw compile -B -q > /dev/null 2>&1); then
                echo "pass" > "$backend_result_file"
            else
                echo "fail" > "$backend_result_file"
            fi
        ) &
        pids+=($!)
    fi

    # Show a simple progress indicator
    echo -n "  "
    while true; do
        local all_done=true
        for pid in "${pids[@]}"; do
            if kill -0 "$pid" 2>/dev/null; then
                all_done=false
                break
            fi
        done
        if [ "$all_done" = "true" ]; then
            break
        fi
        echo -n "."
        sleep 1
    done
    echo ""

    # Wait for all jobs to complete
    for pid in "${pids[@]}"; do
        wait "$pid" 2>/dev/null || true
    done

    # Check results
    local frontend_passed=true
    local backend_passed=true

    if [ "$do_frontend" = "true" ]; then
        if [ -f "$frontend_result_file" ] && [ "$(cat "$frontend_result_file")" = "pass" ]; then
            print_pass "Frontend TypeScript compiles successfully"
        else
            print_warn "Frontend TypeScript compilation had errors"
            frontend_passed=false
        fi
        rm -f "$frontend_result_file"
    fi

    if [ "$do_backend" = "true" ]; then
        if [ -f "$backend_result_file" ] && [ "$(cat "$backend_result_file")" = "pass" ]; then
            print_pass "Backend compiles successfully"
        else
            print_warn "Backend compilation had errors"
            backend_passed=false
        fi
        rm -f "$backend_result_file"
    fi

    if [ "$frontend_passed" = "true" ] && [ "$backend_passed" = "true" ]; then
        return 0
    else
        return 1
    fi
}

check_project_setup() {
    print_check "Project setup"

    # Check if we're in the project root
    if [ ! -f "package.json" ] || [ ! -d "backend" ] || [ ! -d "frontend" ]; then
        print_fail "Not in project root directory or project structure is incomplete"
        print_info "Run this script from the polyrepo root directory"
        return
    fi

    print_pass "Project structure detected"

    # Check if root dependencies are installed
    if [ -d "node_modules" ]; then
        print_pass "Root node_modules installed"
    else
        print_warn "Root node_modules not found"
        if prompt_yes_no "Would you like to install root dependencies now?"; then
            if install_root_dependencies; then
                # Re-check and update status
                if [ -d "node_modules" ]; then
                    print_pass "Root node_modules installed"
                    # Decrement warning since we fixed it
                    WARNINGS=$((WARNINGS - 1))
                fi
            fi
        else
            print_info "Skipped. Run manually: npm install"
        fi
    fi

    # Check husky hooks
    if [ -f ".husky/commit-msg" ]; then
        if [ -x ".husky/commit-msg" ]; then
            print_pass "Husky commit-msg hook installed and executable"
        else
            print_warn "Husky commit-msg hook exists but is not executable"
            print_info "Run: chmod +x .husky/commit-msg"
        fi
    else
        print_warn "Husky commit-msg hook not found"
        print_info "Run: npm install && npx husky"
    fi

    # Track what needs compilation
    local frontend_ready=false
    local backend_ready=false
    local frontend_needs_install=false
    local backend_needs_install=false

    # Check frontend dependencies
    if [ -d "frontend/node_modules" ]; then
        print_pass "Frontend node_modules installed"
        frontend_ready=true
    else
        print_warn "Frontend node_modules not found"
        if prompt_yes_no "Would you like to install frontend dependencies now?"; then
            if install_frontend_dependencies; then
                if [ -d "frontend/node_modules" ]; then
                    print_pass "Frontend node_modules installed"
                    WARNINGS=$((WARNINGS - 1))
                    frontend_ready=true
                fi
            fi
        else
            print_info "Skipped. Run manually: cd frontend && npm install"
        fi
    fi

    # Check Maven local repository
    local m2_repo="$HOME/.m2/repository"
    if [ -d "$m2_repo" ]; then
        if find "$m2_repo" -path "*org/springframework/boot*" -type d 2>/dev/null | head -1 | grep -q .; then
            print_pass "Maven local repository exists with Spring dependencies"
            backend_ready=true
        else
            print_warn "Maven local repository exists but may be missing Spring Boot dependencies"
            backend_needs_install=true
        fi
    else
        print_warn "Maven local repository (~/.m2/repository) not found"
        backend_needs_install=true
    fi

    # Handle backend dependency installation if needed
    if [ "$backend_needs_install" = true ]; then
        if prompt_yes_no "Would you like to compile the backend (downloads dependencies)?"; then
            if [ "$PARALLEL_MODE" = "parallel" ] && [ "$frontend_ready" = true ]; then
                # Will be handled in parallel compilation below
                backend_ready=true
            else
                if install_backend_dependencies; then
                    print_pass "Backend compiled successfully"
                    WARNINGS=$((WARNINGS - 1))
                    backend_ready=true
                fi
            fi
        else
            print_info "Skipped. Run manually: cd backend && ./mvnw compile"
        fi
    fi

    # Offer compilation verification
    if [ "$frontend_ready" = true ] || [ "$backend_ready" = true ]; then
        local do_frontend="false"
        local do_backend="false"

        if [ "$frontend_ready" = true ]; then
            if prompt_yes_no "Would you like to verify frontend TypeScript compiles?"; then
                do_frontend="true"
            fi
        fi

        if [ "$backend_ready" = true ]; then
            if prompt_yes_no "Would you like to verify backend compiles?"; then
                do_backend="true"
            fi
        fi

        # Run compilation checks
        if [ "$do_frontend" = "true" ] || [ "$do_backend" = "true" ]; then
            if [ "$PARALLEL_MODE" = "parallel" ] && [ "$do_frontend" = "true" ] && [ "$do_backend" = "true" ]; then
                # Run both in parallel
                compile_all_parallel "$do_frontend" "$do_backend"
            else
                # Run serially
                if [ "$do_frontend" = "true" ]; then
                    if compile_frontend_typescript; then
                        print_pass "Frontend TypeScript compiles successfully"
                    else
                        print_warn "Frontend TypeScript compilation had errors"
                    fi
                fi
                if [ "$do_backend" = "true" ]; then
                    if install_backend_dependencies; then
                        print_pass "Backend compiles successfully"
                    else
                        print_warn "Backend compilation had errors"
                    fi
                fi
            fi
        fi
    fi
}

check_ports() {
    print_check "Required ports"

    local ports=("3000:Frontend" "8080:Backend" "27017:MongoDB")

    for port_info in "${ports[@]}"; do
        local port="${port_info%%:*}"
        local service="${port_info##*:}"

        if lsof -i ":$port" &> /dev/null; then
            print_warn "Port $port ($service) is already in use"
            print_info "Process: $(lsof -i :$port | tail -1 | awk '{print $1, $2}')"
        else
            print_pass "Port $port ($service) is available"
        fi
    done
}

check_docker_resources() {
    print_check "Docker resources"

    # Check if Docker is running first
    if ! docker info &> /dev/null; then
        print_info "Skipping Docker resource check (Docker not running)"
        return
    fi

    # Get Docker memory limit
    local docker_info=$(docker info 2>/dev/null)

    # Try to get memory from docker info
    local memory_bytes=$(echo "$docker_info" | grep -i "Total Memory" | grep -oE '[0-9]+\.?[0-9]*\s*(GiB|GB|MiB|MB)' | head -1)

    if [ -n "$memory_bytes" ]; then
        # Extract number and unit
        local mem_value=$(echo "$memory_bytes" | grep -oE '[0-9]+\.?[0-9]*')
        local mem_unit=$(echo "$memory_bytes" | grep -oE '(GiB|GB|MiB|MB)')

        # Convert to GB for comparison
        local mem_gb
        case "$mem_unit" in
            GiB|GB) mem_gb=$(echo "$mem_value" | awk '{printf "%.1f", $1}') ;;
            MiB|MB) mem_gb=$(echo "$mem_value" | awk '{printf "%.1f", $1/1024}') ;;
            *) mem_gb=0 ;;
        esac

        local mem_gb_int=$(echo "$mem_gb" | awk '{printf "%d", $1}')

        if [ "$mem_gb_int" -ge "$MIN_DOCKER_MEMORY_GB" ]; then
            print_pass "Docker memory: ${mem_gb}GB (required: ${MIN_DOCKER_MEMORY_GB}GB+)"
        else
            print_warn "Docker memory: ${mem_gb}GB (recommended: ${MIN_DOCKER_MEMORY_GB}GB+)"
            print_info "Increase in Docker Desktop: Settings > Resources > Memory"
        fi
    else
        print_info "Could not determine Docker memory allocation"
    fi

    # Check CPUs allocated to Docker
    local cpus=$(echo "$docker_info" | grep -i "CPUs" | grep -oE '[0-9]+' | head -1)
    if [ -n "$cpus" ]; then
        if [ "$cpus" -ge 2 ]; then
            print_pass "Docker CPUs: $cpus (recommended: 2+)"
        else
            print_warn "Docker CPUs: $cpus (recommended: 2+)"
            print_info "Increase in Docker Desktop: Settings > Resources > CPUs"
        fi
    fi
}

check_disk_space() {
    print_check "Disk space"

    # Get available disk space in the current directory
    local available_kb
    local available_gb

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        available_kb=$(df -k . | tail -1 | awk '{print $4}')
    else
        # Linux
        available_kb=$(df -k . | tail -1 | awk '{print $4}')
    fi

    available_gb=$((available_kb / 1024 / 1024))

    if [ "$available_gb" -ge "$MIN_DISK_SPACE_GB" ]; then
        print_pass "Available disk space: ${available_gb}GB (required: ${MIN_DISK_SPACE_GB}GB+)"
    else
        print_warn "Available disk space: ${available_gb}GB (recommended: ${MIN_DISK_SPACE_GB}GB+)"
        print_info "Free up space for node_modules, Maven cache, and Docker images"
    fi

    # Check Docker disk usage if Docker is running
    if docker info &> /dev/null; then
        local docker_disk=$(docker system df 2>/dev/null | grep -E "^Images|^Containers|^Volumes" | awk '{sum += $4} END {print sum}' 2>/dev/null || echo "")
        if [ -n "$docker_disk" ] && [ "$docker_disk" != "0" ]; then
            print_info "Docker is using approximately ${docker_disk} of disk space"
            print_info "Run 'docker system prune' to reclaim unused space"
        fi
    fi
}

check_single_endpoint() {
    local host="$1"
    local name="$2"
    local result_file="$3"

    if curl -s --connect-timeout "$NETWORK_TIMEOUT" --max-time "$NETWORK_TIMEOUT" "https://$host" > /dev/null 2>&1; then
        echo "pass:$name ($host) is reachable" >> "$result_file"
    elif nc -z -w "$NETWORK_TIMEOUT" "$host" 443 2>/dev/null; then
        echo "pass:$name ($host) is reachable" >> "$result_file"
    else
        echo "warn:$name ($host) is not reachable" >> "$result_file"
    fi
}

check_network_connectivity() {
    print_check "Network connectivity"

    local endpoints=(
        "registry.npmjs.org:npm registry"
        "repo.maven.apache.org:Maven Central"
        "registry-1.docker.io:Docker Hub"
    )

    if [ "$PARALLEL_MODE" = "parallel" ]; then
        # Parallel execution
        local result_file=$(mktemp)
        local pids=()

        for endpoint_info in "${endpoints[@]}"; do
            local host="${endpoint_info%%:*}"
            local name="${endpoint_info##*:}"
            check_single_endpoint "$host" "$name" "$result_file" &
            pids+=($!)
        done

        # Wait for all background jobs
        for pid in "${pids[@]}"; do
            wait "$pid" 2>/dev/null || true
        done

        # Process results
        while IFS= read -r line; do
            local status="${line%%:*}"
            local message="${line#*:}"
            if [ "$status" = "pass" ]; then
                print_pass "$message"
            else
                print_warn "$message"
                print_info "Check your internet connection or proxy settings"
            fi
        done < "$result_file"

        rm -f "$result_file"
    else
        # Serial execution
        for endpoint_info in "${endpoints[@]}"; do
            local host="${endpoint_info%%:*}"
            local name="${endpoint_info##*:}"

            if curl -s --connect-timeout "$NETWORK_TIMEOUT" --max-time "$NETWORK_TIMEOUT" "https://$host" > /dev/null 2>&1; then
                print_pass "$name ($host) is reachable"
            elif nc -z -w "$NETWORK_TIMEOUT" "$host" 443 2>/dev/null; then
                print_pass "$name ($host) is reachable"
            else
                print_warn "$name ($host) is not reachable"
                print_info "Check your internet connection or proxy settings"
            fi
        done
    fi
}

check_docker_state() {
    print_check "Docker state"

    # Check if Docker is running first
    if ! docker info &> /dev/null; then
        print_info "Skipping Docker state check (Docker not running)"
        return
    fi

    # Check for existing polyrepo containers
    local existing_containers=$(docker ps -a --filter "name=polyrepo" --format "{{.Names}}" 2>/dev/null)

    if [ -n "$existing_containers" ]; then
        local container_count=$(echo "$existing_containers" | wc -l | tr -d ' ')
        print_warn "Found $container_count existing polyrepo container(s)"
        echo "$existing_containers" | while read -r container; do
            local status=$(docker inspect --format='{{.State.Status}}' "$container" 2>/dev/null)
            print_info "  - $container ($status)"
        done
        print_info "Run 'docker compose -f docker/docker-compose.yml down' to clean up"
    else
        print_pass "No existing polyrepo containers found"
    fi

    # Check for existing polyrepo volumes
    local existing_volumes=$(docker volume ls --filter "name=polyrepo" --format "{{.Name}}" 2>/dev/null || docker volume ls --filter "name=docker_mongodb" --format "{{.Name}}" 2>/dev/null)

    if [ -n "$existing_volumes" ]; then
        local volume_count=$(echo "$existing_volumes" | wc -l | tr -d ' ')
        print_info "Found $volume_count existing volume(s) (data will persist)"
    fi

    # Check for dangling images that might cause issues
    local dangling_images=$(docker images -f "dangling=true" -q 2>/dev/null | wc -l | tr -d ' ')
    if [ "$dangling_images" -gt 10 ]; then
        print_warn "Found $dangling_images dangling Docker images"
        print_info "Run 'docker image prune' to clean up"
    fi
}

show_team() {
    local team_dir="team"

    if [ ! -d "$team_dir" ]; then
        return
    fi

    local team_files=$(find "$team_dir" -name "*.txt" -type f 2>/dev/null | grep -v "TEMPLATE.txt" | sort)

    if [ -z "$team_files" ]; then
        return
    fi

    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                         MEET THE TEAM                                     ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    while IFS= read -r file; do
        if [ -f "$file" ]; then
            local name=$(grep -i "^name:" "$file" 2>/dev/null | cut -d: -f2- | xargs)
            local location=$(grep -i "^location:" "$file" 2>/dev/null | cut -d: -f2- | xargs)
            local cats=$(grep -i "^cats:" "$file" 2>/dev/null | cut -d: -f2- | xargs)

            if [ -n "$name" ]; then
                echo -e "  ${GREEN}◆${NC} ${name}"
                [ -n "$location" ] && echo -e "    📍 ${location}"
                if [ -n "$cats" ]; then
                    if [ "$cats" -eq 0 ] 2>/dev/null; then
                        echo -e "    🐱 No cats (yet)"
                    elif [ "$cats" -eq 1 ] 2>/dev/null; then
                        echo -e "    🐱 1 cat"
                    else
                        echo -e "    🐱 ${cats} cats"
                    fi
                fi
                echo ""
            fi
        fi
    done <<< "$team_files"
}

check_environment_variables() {
    print_check "Environment variables"

    local required_for_full_setup=0
    local optional_set=0

    # Check for Okta configuration (optional for local, required for deployed)
    if [ -n "$OKTA_ISSUER_URI" ]; then
        print_pass "OKTA_ISSUER_URI is set"
        ((optional_set++))
    else
        print_info "OKTA_ISSUER_URI not set (optional for local development)"
    fi

    if [ -n "$OKTA_JWK_SET_URI" ]; then
        print_pass "OKTA_JWK_SET_URI is set"
        ((optional_set++))
    else
        print_info "OKTA_JWK_SET_URI not set (optional for local development)"
    fi

    # Check for MongoDB URI (optional, has default)
    if [ -n "$MONGODB_URI" ]; then
        print_pass "MONGODB_URI is set"
        ((optional_set++))
    else
        print_info "MONGODB_URI not set (will use default: mongodb://localhost:27017/polyrepo)"
    fi

    # Check for Okteto (optional)
    if [ -n "$OKTETO_TOKEN" ]; then
        print_pass "OKTETO_TOKEN is set (for preview deployments)"
        ((optional_set++))
    fi

    # Check for common proxy settings that might affect connectivity
    if [ -n "$HTTP_PROXY" ] || [ -n "$http_proxy" ]; then
        print_info "HTTP proxy detected: ${HTTP_PROXY:-$http_proxy}"
        print_info "This may affect Docker and npm operations"
    fi

    if [ -n "$HTTPS_PROXY" ] || [ -n "$https_proxy" ]; then
        print_info "HTTPS proxy detected: ${HTTPS_PROXY:-$https_proxy}"
    fi

    if [ -n "$NO_PROXY" ] || [ -n "$no_proxy" ]; then
        print_info "NO_PROXY is configured"
    fi

    if [ $optional_set -eq 0 ]; then
        print_info "No optional environment variables set (this is fine for local development)"
    fi
}

#===============================================================================
# Main
#===============================================================================

main() {
    # Parse command line arguments
    parse_args "$@"

    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║           POLYREPO ENVIRONMENT VERIFICATION                              ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════════════════╝${NC}"

    if [ "$AUTO_INSTALL" = true ]; then
        echo -e "  ${YELLOW}Running with --install: dependencies will be installed automatically${NC}"
    elif [ "$SKIP_INSTALL" = true ]; then
        echo -e "  ${YELLOW}Running with --skip-install: no dependencies will be installed${NC}"
    fi

    # Prompt for parallel mode if not specified
    if [ -z "$PARALLEL_MODE" ]; then
        echo ""
        if prompt_yes_no "Would you like to run slow checks (network, compilation) in parallel for faster results?" "n"; then
            PARALLEL_MODE="parallel"
        else
            PARALLEL_MODE="serial"
        fi
    fi

    if [ "$PARALLEL_MODE" = "parallel" ]; then
        echo -e "  ${BLUE}ℹ${NC} Running in parallel mode for faster execution"
    fi

    print_header "Required Tools"
    check_java
    check_maven
    check_node
    check_npm
    check_docker
    check_docker_compose
    check_git

    print_header "Optional Tools"
    check_optional_tools

    print_header "System Resources"
    check_disk_space
    check_docker_resources

    print_header "Network Connectivity"
    check_network_connectivity

    print_header "Docker State"
    check_docker_state

    print_header "Environment Variables"
    check_environment_variables

    print_header "Project Setup"
    check_project_setup

    print_header "Port Availability"
    check_ports

    # Summary
    print_header "Summary"
    echo ""
    echo -e "  ${GREEN}Passed:${NC}   $PASSED"
    echo -e "  ${RED}Failed:${NC}   $FAILED"
    echo -e "  ${YELLOW}Warnings:${NC} $WARNINGS"
    echo ""

    if [ $FAILED -gt 0 ]; then
        echo -e "  ${RED}Environment check failed. Please fix the issues above.${NC}"
        echo ""
        exit 1
    elif [ $WARNINGS -gt 0 ]; then
        echo -e "  ${YELLOW}Environment check passed with warnings.${NC}"
        echo -e "  ${YELLOW}Consider addressing the warnings for the best experience.${NC}"
        echo ""
        exit 0
    else
        echo -e "  ${GREEN}Environment check passed! You're ready to develop.${NC}"
        echo ""
        echo -e "  Next steps:"
        echo -e "    1. Start services:  ${BLUE}docker compose -f docker/docker-compose.yml up${NC}"
        echo -e "    2. Or run manually:"
        echo -e "       - Backend:  ${BLUE}cd backend && ./mvnw spring-boot:run -Dspring-boot.run.profiles=local${NC}"
        echo -e "       - Frontend: ${BLUE}cd frontend && npm run dev${NC}"

        # Show team members if environment is correctly configured
        show_team

        echo ""
        exit 0
    fi
}

main "$@"
