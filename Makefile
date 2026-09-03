.PHONY: help build up down logs ps restart stop start clean dev-up dev-down pull update version

# Colors
GREEN := \033[0;32m
BLUE := \033[0;34m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(BLUE)╔════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║   The Last of Us Part II — Docker Management Commands   ║$(NC)"
	@echo "$(BLUE)╚════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(GREEN)Production:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; /^(up|down|restart|logs|ps|stop|start|pull|update)/ {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)Development:$(NC)"
	@echo "  $(YELLOW)dev-up$(NC)               Build & start locally"
	@echo "  $(YELLOW)dev-down$(NC)             Stop development mode"
	@echo ""
	@echo "$(GREEN)Maintenance:$(NC)"
	@echo "  $(YELLOW)build$(NC)                Rebuild image locally"
	@echo "  $(YELLOW)clean$(NC)                Remove all containers & images"
	@echo ""

up: ## Start the application
	@echo "$(GREEN)▶ Starting tlou2-guide...$(NC)"
	docker compose up -d
	@echo "$(GREEN)✓ Container started!$(NC)"
	@echo "$(BLUE)→ Access at http://localhost:$(PORT:-8080)$(NC)"

down: ## Stop and remove the application
	@echo "$(YELLOW)⏹ Stopping tlou2-guide...$(NC)"
	docker compose down
	@echo "$(GREEN)✓ Container removed!$(NC)"

start: ## Start the application (if already created)
	@echo "$(GREEN)▶ Starting tlou2-guide...$(NC)"
	docker compose start
	@echo "$(GREEN)✓ Container started!$(NC)"

stop: ## Stop the application
	@echo "$(YELLOW)⏹ Stopping tlou2-guide...$(NC)"
	docker compose stop
	@echo "$(GREEN)✓ Container stopped!$(NC)"

restart: ## Restart the application
	@echo "$(YELLOW)🔄 Restarting tlou2-guide...$(NC)"
	docker compose restart
	@echo "$(GREEN)✓ Container restarted!$(NC)"

logs: ## View application logs
	@echo "$(BLUE)📋 Logs (Ctrl+C to exit):$(NC)"
	docker compose logs -f --tail=50

ps: ## Show container status
	@echo "$(BLUE)📦 Container Status:$(NC)"
	docker compose ps

build: ## Build the image locally
	@echo "$(GREEN)🔨 Building Docker image...$(NC)"
	docker compose build
	@echo "$(GREEN)✓ Image built!$(NC)"

dev-up: ## Start in development mode (local build)
	@echo "$(GREEN)▶ Starting in development mode...$(NC)"
	docker compose -f docker-compose.dev.yml up -d --build
	@echo "$(GREEN)✓ Development container started!$(NC)"
	@echo "$(BLUE)→ Access at http://localhost:$(PORT:-8080)$(NC)"

dev-down: ## Stop development mode
	@echo "$(YELLOW)⏹ Stopping development container...$(NC)"
	docker compose -f docker-compose.dev.yml down
	@echo "$(GREEN)✓ Development container removed!$(NC)"

pull: ## Pull the latest image from GHCR
	@echo "$(GREEN)📥 Pulling latest image...$(NC)"
	docker pull ghcr.io/tisme972/tlou2-safe-and-manual:latest
	@echo "$(GREEN)✓ Image updated!$(NC)"

update: pull restart ## Pull latest and restart
	@echo "$(GREEN)✓ Application updated!$(NC)"

clean: ## Remove all containers, volumes and images
	@echo "$(RED)⚠ This will remove all containers, volumes and images!$(NC)"
	@read -p "Are you sure? (y/N) " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		echo "$(RED)🗑 Cleaning up...$(NC)"; \
		docker compose down -v; \
		docker image rm ghcr.io/tisme972/tlou2-safe-and-manual:latest -f 2>/dev/null || true; \
		echo "$(GREEN)✓ Cleanup complete!$(NC)"; \
	else \
		echo "$(YELLOW)Cancelled.$(NC)"; \
	fi

.DEFAULT_GOAL := help
