#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CONTAINER_NAME="tlou2-guide"
IMAGE_NAME="ghcr.io/tisme972/tlou2-safe-and-manual"
DEFAULT_PORT=8080

# Display banner
show_banner() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║   The Last of Us Part II — Docker Management Script     ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Show help
show_help() {
    show_banner
    cat << EOF
${GREEN}Usage:${NC} ./manage.sh [command] [options]

${GREEN}Commands:${NC}
  ${YELLOW}start${NC}         Start the application
  ${YELLOW}stop${NC}          Stop the application
  ${YELLOW}restart${NC}       Restart the application
  ${YELLOW}logs${NC}          View application logs
  ${YELLOW}status${NC}        Show container status
  ${YELLOW}update${NC}        Pull latest image and restart
  ${YELLOW}clean${NC}         Remove everything
  ${YELLOW}dev${NC}           Start in development mode
  ${YELLOW}dev-stop${NC}      Stop development mode
  ${YELLOW}help${NC}          Show this help message

${GREEN}Options:${NC}
  --port PORT    Specify port (default: 8080)

${GREEN}Examples:${NC}
  ./manage.sh start
  ./manage.sh start --port 9090
  ./manage.sh logs
  ./manage.sh dev

EOF
}

# Parse arguments
PORT=$DEFAULT_PORT
COMMAND=$1

for arg in "$@"; do
    if [[ "$arg" == "--port" ]]; then
        PORT="${!#}"
    fi
done

# Check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}✗ Docker is not installed!${NC}"
        echo "Please install Docker Desktop first"
        exit 1
    fi
}

# Start application
start_app() {
    show_banner
    echo -e "${GREEN}▶ Starting tlou2-guide on port ${PORT}...${NC}"
    PORT=$PORT docker compose up -d
    sleep 2
    
    if docker ps | grep -q $CONTAINER_NAME; then
        echo -e "${GREEN}✓ Container started successfully!${NC}"
        echo -e "${BLUE}→ Access at http://localhost:${PORT}${NC}"
        docker compose ps
    else
        echo -e "${RED}✗ Failed to start container${NC}"
        docker compose logs
        exit 1
    fi
}

# Stop application
stop_app() {
    show_banner
    echo -e "${YELLOW}⏹ Stopping tlou2-guide...${NC}"
    docker compose stop
    echo -e "${GREEN}✓ Container stopped!${NC}"
}

# Restart application
restart_app() {
    show_banner
    echo -e "${YELLOW}🔄 Restarting tlou2-guide...${NC}"
    docker compose restart
    sleep 2
    echo -e "${GREEN}✓ Container restarted!${NC)"
    echo -e "${BLUE}→ Access at http://localhost:${PORT}${NC}"
}

# Show logs
show_logs() {
    show_banner
    echo -e "${BLUE}📋 Logs (press Ctrl+C to exit):${NC}"
    echo ""
    docker compose logs -f --tail=100
}

# Show status
show_status() {
    show_banner
    echo -e "${BLUE}📦 Container Status:${NC}"
    echo ""
    docker compose ps
    echo ""
    
    if docker ps | grep -q $CONTAINER_NAME; then
        echo -e "${GREEN}✓ Container is running!${NC}"
        PORT=$(docker compose ps --format "table {{.Ports}}" | tail -1 | grep -oP ':\K\d+(?=->)')
        if [ ! -z "$PORT" ]; then
            echo -e "${BLUE}→ Access at http://localhost:${PORT}${NC}"
        fi
    else
        echo -e "${YELLOW}⚠ Container is not running${NC}"
    fi
}

# Update application
update_app() {
    show_banner
    echo -e "${GREEN}📥 Pulling latest image...${NC}"
    docker pull ${IMAGE_NAME}:latest
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Image updated!${NC}"
        echo -e "${YELLOW}🔄 Restarting container...${NC}"
        docker compose up -d
        sleep 2
        echo -e "${GREEN}✓ Application updated and restarted!${NC}"
        echo -e "${BLUE}→ Access at http://localhost:${PORT}${NC}"
    else
        echo -e "${RED}✗ Failed to pull image${NC}"
        exit 1
    fi
}

# Clean everything
clean_all() {
    show_banner
    echo -e "${RED}⚠ This will remove all containers, volumes and images!${NC}"
    read -p "Are you sure? (y/N) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}🗑 Cleaning up...${NC}"
        docker compose down -v
        docker image rm ${IMAGE_NAME}:latest -f 2>/dev/null || true
        echo -e "${GREEN}✓ Cleanup complete!${NC}"
    else
        echo -e "${YELLOW}Cancelled.${NC}"
    fi
}

# Development mode
dev_mode() {
    show_banner
    echo -e "${GREEN}▶ Starting in development mode...${NC}"
    echo -e "${YELLOW}Building and starting container...${NC}"
    PORT=$PORT docker compose -f docker-compose.dev.yml up -d --build
    sleep 2
    
    if docker ps | grep -q $CONTAINER_NAME; then
        echo -e "${GREEN}✓ Development container started!${NC}"
        echo -e "${BLUE}→ Access at http://localhost:${PORT}${NC}"
        echo -e "${YELLOW}→ Local changes reflected automatically${NC}"
        echo ""
        echo "Press Ctrl+C to exit"
        docker compose -f docker-compose.dev.yml logs -f --tail=50
    else
        echo -e "${RED}✗ Failed to start container${NC}"
        exit 1
    fi
}

# Stop development mode
dev_stop() {
    show_banner
    echo -e "${YELLOW}⏹ Stopping development container...${NC}"
    docker compose -f docker-compose.dev.yml down
    echo -e "${GREEN}✓ Development container removed!${NC}"
}

# Main logic
check_docker

case "$COMMAND" in
    start)
        start_app
        ;;
    stop)
        stop_app
        ;;
    restart)
        restart_app
        ;;
    logs)
        show_logs
        ;;
    status|ps)
        show_status
        ;;
    update)
        update_app
        ;;
    clean)
        clean_all
        ;;
    dev)
        dev_mode
        ;;
    dev-stop)
        dev_stop
        ;;
    help|--help|-h|"")
        show_help
        ;;
    *)
        echo -e "${RED}Unknown command: $COMMAND${NC}"
        echo "Use './manage.sh help' for usage information"
        exit 1
        ;;
esac
