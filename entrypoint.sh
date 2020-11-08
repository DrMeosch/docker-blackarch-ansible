#!/usr/bin/env bash
[[ "$USER_ID" == "$(id -u devops)" && "$GROUP_ID" == "$(id -g devops)" ]] || usermod --uid "$USER_ID" --gid "$GROUP_ID" penelope
exec sudo --user devops -- "$@"

