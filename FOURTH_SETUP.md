# n8n Local Development & Docker Setup

## Prerequisites

- Node.js 22+
- pnpm 10.22.0+
- Docker & Docker Compose

## Quick Start

### 1. Install Dependencies

```bash
# Install pnpm globally
npm install -g pnpm@10.22.0

# Install project dependencies
pnpm install
```

### 2. Build n8n

```bash
# Build entire project (takes ~2 minutes)
pnpm build > build.log 2>&1

# Check for errors
tail -n 50 build.log
```

### 3. Run Locally (Development)

```bash
# Start n8n
pnpm start

# Access at http://localhost:5678
```

## Docker Setup

### Build Docker Images

```bash
# Build n8n and runner images (takes ~7 minutes)
pnpm build:docker

# Verify images created
docker images | grep n8nio
# Should show:
#   n8nio/n8n:local
#   n8nio/runners:local
```

### Run with Docker Compose

```bash
# Start containers
docker-compose up -d

# View logs
docker-compose logs -f

# Access at http://localhost:5679

# Stop containers (data persists)
docker-compose stop

# Start again
docker-compose start

# Stop and remove containers (data persists)
docker-compose down

# Stop and remove everything including data ⚠️
docker-compose down -v
```

### Rebuild After Changes

```bash
# Rebuild n8n
pnpm build

# Rebuild Docker images
pnpm build:docker

# Restart containers
docker-compose down
docker-compose up -d
```

## Fourth-Branded Docker Images

### Building Fourth Images

To build only the Fourth-branded Docker images (when on `feat/white-labeling` branch):

```bash
# Build Fourth-branded images
pnpm build:docker:fourth

# This creates:
#   fourth/intelligence-studio:local (main app)
#   fourth/studio-runners:local (Python task runner)
```

### Restarting Fourth Containers

After rebuilding, restart the Fourth containers to use the new images:

```bash
# Stop and start with new image
docker-compose -f docker-compose.fourth.yml down
docker-compose -f docker-compose.fourth.yml up -d

# Or just restart (uses existing image)
docker-compose -f docker-compose.fourth.yml restart
```

**Note:** Use `down` then `up -d` to ensure the newly built image is used. The `restart` command reuses the existing container/image.

### Building Vanilla Images

To build vanilla n8n images (when on `master` branch):

```bash
# Switch to master branch
git checkout master

# Build vanilla images
pnpm build:docker

# This creates:
#   n8nio/n8n:local
#   n8nio/runners:local
```

## Data Locations

- **Local dev**: `~/.n8n/database.sqlite`
- **Docker**: `n8n_data` volume (managed by Docker)

Each environment has separate databases - owner accounts and data are NOT shared.

### What's Stored in the Database

All n8n data is stored in `/home/node/.n8n` inside the container (mapped to Docker volumes):

- **Workflows**: All workflow definitions, nodes, connections, settings
- **Agents**: 
  - Chat Hub Agents (stored in `chat_hub_agents` table)
  - Workflow-based agents (stored as workflows in `workflow_entity` table)
- **Credentials**: API keys, authentication tokens, connection details
- **Executions**: Workflow execution history and results
- **Users**: User accounts, roles, permissions
- **Data Tables**: Custom data tables created in n8n
- **Settings**: Application and user settings

**Default Database**: SQLite (`database.sqlite` file in the volume)

**Production Recommendation**: Use PostgreSQL or MySQL for better performance and scalability.

## Running Multiple Instances (Vanilla + Fourth)

You can run both vanilla n8n and Fourth Intelligence Studio simultaneously for testing:

```bash
# Start vanilla n8n on port 5679
docker-compose up -d

# Start Fourth on port 5680
docker-compose -f docker-compose.fourth.yml up -d
```

### ⚠️ Browser Cookie Conflict

**Problem**: When accessing both instances, you'll see "Unauthorized" errors:
- "Problem loading workflows - Unauthorized"
- "Error loading data tables - Unauthorized"

**Cause**: Both run on `localhost` (different ports), and browsers share cookies across all localhost ports. Logging into one instance sends wrong cookies to the other.

**Solution**: Use an **incognito/private window** for one instance:
- Vanilla: `http://localhost:5679` (normal browser)
- Fourth: `http://localhost:5680` (incognito/private window)

**Alternative solutions**:
- Use different hostnames: `localhost:5679` vs `127.0.0.1:5680`
- Use separate browser profiles
- Clear localhost cookies when switching

See `DOCKER_REFERENCE.md` for detailed Docker management instructions.

## Kubernetes Deployment

### Can I Use the Same Docker Image?

**Yes!** The same Docker image (`fourth/intelligence-studio:local`) can be deployed to Kubernetes. However, you need to:

1. **Push the image to a container registry** (Docker Hub, Azure Container Registry, etc.)
2. **Configure Kubernetes manifests** with proper:
   - Persistent volumes for data storage
   - Environment variables
   - Service configurations
   - Secrets for credentials

### Transferring Agents and Workflows

**Yes, agents and workflows are transferable!** All data is stored in the database, which can be migrated between environments.

#### Option 1: Shared Database (Recommended)

Use the same PostgreSQL/MySQL database for both Docker and Kubernetes:

```yaml
# In Kubernetes deployment
env:
  - name: DB_TYPE
    value: "postgresdb"
  - name: DB_POSTGRESDB_HOST
    value: "your-postgres-host"
  - name: DB_POSTGRESDB_DATABASE
    value: "n8n"
  - name: DB_POSTGRESDB_USER
    valueFrom:
      secretKeyRef:
        name: n8n-db-secret
        key: username
  - name: DB_POSTGRESDB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: n8n-db-secret
        key: password
```

**Benefits**: 
- Agents/workflows immediately available in both environments
- No migration needed
- Single source of truth

#### Option 2: Export/Import Database

**From Docker (SQLite)**:
```bash
# Copy database from Docker volume
docker run --rm -v fourth-intelligence-studio-data:/data -v $(pwd):/backup \
  alpine tar czf /backup/n8n-database-backup.tar.gz -C /data .

# Extract database.sqlite from backup
tar xzf n8n-database-backup.tar.gz
```

**To Kubernetes (PostgreSQL)**:
```bash
# Use n8n's built-in export/import features via UI
# Or use database migration tools (pgloader, etc.)
```

#### Option 3: Export/Import via n8n UI

1. **Export from Docker instance**:
   - Go to Settings → Import/Export
   - Export workflows, credentials, and data tables
   
2. **Import to Kubernetes instance**:
   - Upload the exported JSON file
   - All workflows, agents, and data will be imported

**Note**: Chat Hub Agents are stored in the database and will transfer automatically with database migration.

### Kubernetes Deployment Checklist

1. ✅ Build and push image to registry:
   ```bash
   # Tag for registry
   docker tag fourth/intelligence-studio:local your-registry/fourth/intelligence-studio:v1.0.0
   
   # Push to registry
   docker push your-registry/fourth/intelligence-studio:v1.0.0
   ```

2. ✅ Create PersistentVolumeClaim for `/home/node/.n8n`

3. ✅ Configure environment variables (same as Docker Compose)

4. ✅ Set up PostgreSQL/MySQL database (recommended for production)

5. ✅ Configure secrets for database credentials

6. ✅ Deploy Python runner separately (if using external mode)

7. ✅ Set up ingress/load balancer for external access

### Important Notes

- **Image Compatibility**: The same image works in Docker and Kubernetes
- **Data Persistence**: Use PersistentVolumes in Kubernetes (equivalent to Docker volumes)
- **Database**: SQLite works for single-pod deployments, but PostgreSQL/MySQL is recommended for:
  - Multi-pod deployments (scaling)
  - Production environments
  - Better performance
- **Agents Transfer**: All agents (Chat Hub and workflow-based) transfer with the database
- **Credentials**: Ensure credentials are properly migrated (may need re-authentication)

## Enterprise License Features

### Local Development vs Production

**Good News**: Most enterprise features work fully on your local machine with Docker! The enterprise license unlocks features based on the license key, not the deployment environment.

### Features That Work Locally (Single Instance)

These enterprise features work perfectly on a local Docker setup:

- ✅ **Sharing**: Share workflows with team members
- ✅ **LDAP/SAML/OIDC**: Single Sign-On authentication
- ✅ **MFA Enforcement**: Multi-factor authentication requirements
- ✅ **Log Streaming**: Stream execution logs to external services
- ✅ **Advanced Execution Filters**: Filter executions with advanced criteria
- ✅ **Variables**: Environment and instance variables
- ✅ **Source Control**: Git integration for workflows
- ✅ **External Secrets**: Integration with secret management systems
- ✅ **Debug in Editor**: Debug workflows directly in the editor
- ✅ **Advanced Permissions**: Role-based access control (RBAC)
- ✅ **API Key Scopes**: Scoped API keys for security
- ✅ **Workflow Diffs**: Compare workflow versions
- ✅ **Custom Roles**: Create custom user roles
- ✅ **AI Assistant**: AI-powered workflow assistance
- ✅ **AI Builder**: AI workflow generation
- ✅ **Folders**: Organize workflows in folders
- ✅ **Insights**: Workflow analytics and dashboards
- ✅ **Binary Data S3**: Store binary data in S3 (requires S3 configuration)

### Features Requiring Specific Infrastructure

Some features require additional infrastructure beyond a single Docker container:

#### 1. Queue Mode & Worker View

**Requires**: Redis + PostgreSQL

**What it does**: Separates workflow execution into main instances (handle UI/API) and worker instances (execute workflows).

**Local setup possible**: Yes, but requires:
- PostgreSQL database (can run in Docker)
- Redis (can run in Docker)
- Multiple containers (main + workers)

**Why you might need it**: 
- High-volume workflow execution
- Better resource isolation
- Horizontal scaling

**Local development**: Not typically needed unless testing scaling features.

#### 2. Multiple Main Instances

**Requires**: Queue Mode + Redis + PostgreSQL + Enterprise License

**What it does**: Run multiple main instances for high availability and load distribution.

**Local setup possible**: Yes, but complex (multiple main containers + workers + Redis + PostgreSQL).

**Why you might need it**:
- High availability (HA)
- Load balancing across multiple main instances
- Production deployments

**Local development**: Not needed - single main instance is sufficient.

#### 3. Worker View Feature

**Requires**: Queue Mode (which requires Redis + PostgreSQL)

**What it does**: View and manage worker instances in the UI.

**Local setup possible**: Yes, if you set up queue mode locally.

**Local development**: Not needed unless testing worker management.

### Summary

**For Local Development**: 
- ✅ **99% of enterprise features work** on a single Docker container
- ✅ **No Kubernetes required** for most features
- ✅ **Agents, workflows, and all core features** work perfectly locally

**Only if you need**:
- High-volume execution → Queue Mode (Redis + PostgreSQL)
- High Availability → Multiple Main Instances (Queue Mode + Redis + PostgreSQL)
- Worker Management UI → Worker View (requires Queue Mode)

**Recommendation**: Start with a single Docker container. You'll have access to all enterprise features except those specifically requiring queue mode. When you're ready to deploy to Kubernetes for production, you can add queue mode and multi-main setup if needed.

### Testing Queue Mode Locally

If you want to test queue mode locally (optional):

```bash
# Using docker-compose with PostgreSQL and Redis
# See: packages/@n8n/benchmark/scripts/n8n-setups/scaling-single-main/docker-compose.yml
```

But this is **not required** for most development work!

## Git Workflow

### Working with Branches

```bash
# Create a new feature branch
git checkout -b feat/your-feature-name

# Make your changes and commit
git add .
git commit -m "feat: description of changes"

# View branch status
git branch -v
```

### Merging to Your Fork's Master

Since this is your personal fork, merge directly instead of creating PRs:

```bash
# Switch to master
git checkout master

# Merge your feature branch
git merge feat/your-feature-name

# Push to your fork
git push origin master

# Optional: Delete merged feature branch
git branch -d feat/your-feature-name
```

### Checking Remote Configuration

```bash
# Verify remotes
git remote -v

# Should show:
# origin    https://github.com/YOUR-USERNAME/n8n_fourth.git (your fork)
# upstream  https://github.com/n8n-io/n8n.git (original repo)
```

**Note:** Always push to `origin` (your fork), not `upstream` (original n8n repo).

## Useful Commands

```bash
# Check running containers
docker ps

# View specific logs
docker logs n8n -f

# Access container shell
docker exec -it n8n sh

# Backup Docker volume
docker run --rm -v n8n_fourth_n8n_data:/data -v $(pwd):/backup \
  alpine tar czf /backup/n8n-backup.tar.gz -C /data .
```

