#!/bin/bash
set -x
docker compose run --rm jenkins_agent_npm sh -c "cd workspace; ./test.sh"