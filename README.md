OASIS Research 🏜️

What is OASIS?

OASIS is a unified research intelligence platform combining:

- Literature discovery (Sci-Hub + Google Scholar + arXiv)
- Knowledge management (Notion + Obsidian)
- Research gap identification
- AI-powered research assistance

Mission: Reduce academic research effort by 80%.

---

Quick Start

Prerequisites

- Docker & Docker Compose
- Go 1.21+
- Node.js 18+
- Python 3.11+
- PostgreSQL 15+
- Redis 7+
- Qdrant 1.7+

Development Setup

# Clone repository
git clone https://github.com/GSF-001/OASIS-information.git
cd OASIS-information

# Copy environment template
cp .env.example .env

# Start all services
docker-compose up -d

# Run migrations
make migrate

# Start development environment
make dev

---

Monorepo Structure

See "ARCHITECTURE.md" (./ARCHITECTURE.md) for complete system design.

- services/ - Microservices (Go, Node.js, Python)
- packages/ - Shared types, utilities, SDKs
- frontend/ - React + Next.js web application
- infrastructure/ - Docker, Kubernetes, Terraform configurations
- docs/ - API and system documentation

---

Deployment

Local Kubernetes

make deploy-local

Cloud Deployment

See "deployment/README.md" (./deployment/README.md)

---

Documentation

- "Architecture" (./ARCHITECTURE.md)
- "API Docs" (./docs/api/README.md)
- "Database" (./docs/database/README.md)
- "Development Guide" (./docs/development/README.md)
- "Operations Guide" (./docs/operations/README.md)

---

Contributing

See "CONTRIBUTING.md" (./CONTRIBUTING.md)
