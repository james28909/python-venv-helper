# ~/.oh-my-zsh/custom/functions.zsh

function venv() {
    local venv_dir="$HOME/.venv"
    local cmd="$1"
    local arg="$2"

    [[ -z "$cmd" ]] && {
        if [[ -d "$venv_dir" ]]; then
            printf "available virtual environments:\n"
            find "$venv_dir" -mindepth 1 -maxdepth 1 -type d | while read -r d; do
                [[ -f "$d/bin/activate" ]] && basename "$d"
            done | sort
            return 0
        else
            printf "venv directory not found: %s\n" "$venv_dir"
            return 1
        fi
    }

    case "$cmd" in
        create|c)
            [[ -n "$arg" ]] || { printf "usage: venv create <name>\n"; return 1; }
            python3 -m venv "$venv_dir/$arg"
            if [[ $? -eq 0 ]]; then
                printf "created venv at %s\n" "$venv_dir/$arg"
            else
                printf "failed to create venv at %s\n" "$venv_dir/$arg"
                return 1
            fi
            ;;
        activate|a)
            [[ -n "$arg" ]] || { printf "usage: venv activate <name>\n"; return 1; }
            local activate_path="$venv_dir/$arg/bin/activate"
            [[ -f "$activate_path" ]] && source "$activate_path" && printf "activated venv: %s\n" "$arg" || {
                printf "venv not found: %s\n" "$arg"; return 1
            }
            ;;
        list|l)
            [[ -n "$arg" ]] || { printf "usage: venv list <name>\n"; return 1; }
            local list_path="$venv_dir/$arg"
            [[ -x "$list_path/bin/python" ]] && {
                printf "\nVirtual Environment: %s\n" "$arg"
                printf "Python Version: "
                "$list_path/bin/python" --version
                printf "Location: %s\n" "$list_path"
                printf "----------------------------------------\n"
                printf "%-20s %-10s\n" "Package" "Version"
                printf "%-20s %-10s\n" "--------------------" "----------"
                "$list_path/bin/python" -m pip list --format=columns 2>/dev/null || printf "pip not available\n"
                printf "----------------------------------------\n\n"
            } || {
                printf "venv not found: %s\n" "$arg"; return 1
            }
            ;;
        find|f)
            [[ -n "$arg" ]] || { printf "usage: venv find <package>\n"; return 1; }
            local found=0
            for d in "$venv_dir"/*; do
                [[ -x "$d/bin/python" ]] || continue
                if "$d/bin/python" -m pip show "$arg" >/dev/null 2>&1; then
                    printf "%s has %s\n" "$(basename "$d")" "$arg"
                    found=1
                fi
            done
            [[ "$found" -eq 0 ]] && { printf "no venv has %s\n" "$arg"; return 1; }
            ;;
        nuke|n)
            [[ -n "$arg" ]] || { printf "usage: venv nuke <name>\n"; return 1; }
            local target="$venv_dir/$arg"
            [[ -d "$target" && -f "$target/bin/activate" ]] && {
                rm -rf "$target"
                printf "nuked venv: %s\n" "$arg"
            } || {
                printf "no valid venv to nuke at: %s\n" "$target"; return 1
            }
            ;;
        install|i)
            [[ -n "$arg" ]] || { printf "usage: venv install <name>\n"; return 1; }
            local install_path="$venv_dir/$arg"
            [[ -f "$install_path/requirements.txt" ]] && {
                "$install_path/bin/python" -m pip install -r "$install_path/requirements.txt"
                printf "Installed requirements for %s\n" "$arg"
            } || {
                printf "requirements.txt not found in %s\n" "$install_path"; return 1
            }
            ;;
        upgrade|u)
            [[ -n "$arg" ]] || { printf "usage: venv upgrade <name>\n"; return 1; }
            local upgrade_path="$venv_dir/$arg"
            [[ -x "$upgrade_path/bin/python" ]] && {
                "$upgrade_path/bin/python" -m pip install --upgrade pip setuptools
                printf "Upgraded pip and setuptools in %s\n" "$arg"
            } || {
                printf "venv not found: %s\n" "$arg"; return 1
            }
            ;;
        export|e)
            [[ -n "$arg" ]] || { printf "usage: venv export <name>\n"; return 1; }
            local export_path="$venv_dir/$arg"
            [[ -x "$export_path/bin/python" ]] && {
                "$export_path/bin/python" -m pip freeze > "$export_path/requirements.txt"
                printf "Exported requirements to %s/requirements.txt\n" "$export_path"
            } || {
                printf "venv not found: %s\n" "$arg"; return 1
            }
            ;;       
        help|h)
            printf "venv [command] [arg]\n\n"
            printf "commands:\n"
            printf "  create | c <name>     create virtualenv\n"
            printf "  activate | a <name>   activate virtualenv\n"
            printf "  list | l <name>       list packages in virtualenv\n"
            printf "  find | f <package>    search for package in all envs\n"
            printf "  nuke | n <name>       delete virtualenv\n"
            printf "  upgrade | u <name>    upgrade pip and setuptools in virtualenv\n"
            printf "  export | e <name>     export requirements.txt from virtualenv\n"
            printf "  install | i <name>    install from requirements.txt in virtualenv\n"
            printf "  (no args)             list all available virtual environments\n"
            ;;
        *)
            printf "unknown command: %s\n" "$cmd"
            printf "use 'venv help' to list valid commands\n"
            return 1
            ;;
    esac
}
