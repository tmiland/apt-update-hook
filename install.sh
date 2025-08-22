#!/usr/bin/env bash

install() {
	echo "Installing apt update hook"
  cp -rp ./80apt-update /etc/apt/apt.conf.d/80apt-update
  chmod 644 /etc/apt/apt.conf.d/80apt-update
  cp -rp ./apt_update_hook.sh /usr/bin/apt_update_hook.sh
  chmod 755 /usr/bin/apt_update_hook.sh
	echo "Done."
}

uninstall() {
echo "Unstalling apt update hook"
rm -rf /etc/apt/apt.conf.d/80apt-update
rm -rf /usr/bin/apt_update_hook.sh
echo "Done."
}

reinstall() {
  uninstall
  install
}

usage() {
  cat <<'EOF'

  Options are:

    --install                      | -i
    --uninstall                    | -u
    --reinstall                    | -r
EOF
}

ARGS=()
while [[ $# -gt 0 ]]
do
  case $1 in
    --help | -h)
      usage
      exit 0
      ;;
    --install | -i)
      install
      exit 0
      ;;
    --uninstall | -u)
      uninstall
      exit 0
      ;;
    --reinstall | -r)
      reinstall
      exit 0
      ;;
    --*|-*)
      printf '..%s..' "$1\\n\\n"
      usage
      exit 1
      ;;
    *)
      ARGS+=("$1")
      shift
      ;;
  esac
done

set -- "${ARGS[@]}"

exit 0
