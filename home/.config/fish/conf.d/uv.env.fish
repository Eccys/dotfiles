set -l uv_env_file "$HOME/.local/bin/env.fish"
if test -r "$uv_env_file"
    source "$uv_env_file"
end
