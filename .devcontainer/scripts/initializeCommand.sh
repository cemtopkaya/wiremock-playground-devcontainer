#!/bin/bash

envPath=".devcontainer/.env"

# Function to write a key=value pair into the .env file if the value is not empty
write_to_env() {
  local key="$1"
  local value="$2"
  if [[ -n "$value" ]]; then
    echo "${key}=${value}" >> "$envPath"
  fi
}

set_workspace() {

  # Clear existing .env file before writing
  > "$envPath"

  # Get the absolute path of the current workspace
  CURRENT_WORKSPACE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

  echo "Current workspace path: $CURRENT_WORKSPACE_PATH"

  # For volume binding in docker-compose-dev.yml we need the absolute path of the workspace on the host
  write_to_env "WORKSPACE_PATH_ON_HOST" "$CURRENT_WORKSPACE_PATH"
  write_to_env "WIREMOCK_DIRECTORY" "/home/wiremock/mappings+files"
  write_to_env "WIREMOCK_PORT" "80"

  # Also create any necessary directories in the container path structure
  # This ensures the directory structure exists when Docker tries to mount
  mkdir -p "$CURRENT_WORKSPACE_PATH" 2>/dev/null || true

  echo "Environment file created at: $envPath"
  echo "Workspace path set to: $CURRENT_WORKSPACE_PATH"

  set -a
  echo ">>>>> Current directory: $(pwd)"
  source "$(dirname "$0")/../.env" 2>/dev/null || true
  echo ">>>>> WORKSPACE_PATH_ON_HOST: $WORKSPACE_PATH_ON_HOST"
  set +a
}

main() {
  set_workspace
}

main

