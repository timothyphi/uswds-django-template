#!/bin/bash
# USWDS Django Template - Docker Compose Management Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker and Docker Compose are installed
check_dependencies() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed or not in PATH"
        exit 1
    fi

    if ! docker compose version &> /dev/null; then
        print_error "Docker Compose is not installed or not in PATH"
        exit 1
    fi

    print_success "Docker and Docker Compose are available"
}

# Function to start the services
start_services() {
    print_status "Starting USWDS Django Template services..."

    # Ensure .env.toml exists
    if [ ! -f ".env.toml" ]; then
        print_warning ".env.toml not found, copying from sample.env.toml"
        cp sample.env.toml .env.toml
        print_warning "Please update .env.toml with your configuration before running again"
        exit 1
    fi

    docker compose up --build -d mssql redis
    print_status "Waiting for database and Redis to be ready..."
    sleep 30

    docker compose up --build django
}

# Function to stop the services
stop_services() {
    print_status "Stopping USWDS Django Template services..."
    docker compose down
    print_success "Services stopped"
}

# Function to restart the services
restart_services() {
    stop_services
    start_services
}

# Function to view logs
view_logs() {
    local service="${1:-}"
    if [ -n "$service" ]; then
        print_status "Showing logs for $service..."
        docker compose logs -f "$service"
    else
        print_status "Showing logs for all services..."
        docker compose logs -f
    fi
}

# Function to run Django management commands
django_manage() {
    print_status "Running Django management command: $*"
    docker compose exec django python server/manage.py "$@"
}

# Function to access the database
db_shell() {
    print_status "Connecting to SQL Server database..."
    docker compose exec mssql /opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P 'YourStrong@Password123' -C
}

# Function to access Redis CLI
redis_shell() {
    print_status "Connecting to Redis..."
    docker compose exec redis redis-cli
}

# Function to show service status
status() {
    print_status "Service status:"
    docker compose ps
}

# Function to clean up everything
clean() {
    print_warning "This will remove all containers, volumes, and images. Are you sure? (y/N)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
        print_status "Cleaning up..."
        docker compose down -v --rmi all
        print_success "Cleanup completed"
    else
        print_status "Cleanup cancelled"
    fi
}

# Function to show help
show_help() {
    echo "USWDS Django Template - Docker Compose Management Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start, up      Start all services"
    echo "  stop, down     Stop all services"
    echo "  restart        Restart all services"
    echo "  logs [service] View logs (optionally for specific service)"
    echo "  status, ps     Show service status"
    echo "  manage [cmd]   Run Django management command"
    echo "  shell-db       Connect to SQL Server database"
    echo "  shell-redis    Connect to Redis CLI"
    echo "  clean          Remove all containers, volumes, and images"
    echo "  help           Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start                    # Start all services"
    echo "  $0 logs django             # View Django logs"
    echo "  $0 manage migrate          # Run Django migrations"
    echo "  $0 manage createsuperuser  # Create Django superuser"
    echo "  $0 shell-db                # Connect to database"
}

# Main script logic
main() {
    check_dependencies

    case "${1:-help}" in
        start|up)
            start_services
            ;;
        stop|down)
            stop_services
            ;;
        restart)
            restart_services
            ;;
        logs)
            shift
            view_logs "$@"
            ;;
        status|ps)
            status
            ;;
        manage)
            shift
            django_manage "$@"
            ;;
        shell-db)
            db_shell
            ;;
        shell-redis)
            redis_shell
            ;;
        clean)
            clean
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Unknown command: $1"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"