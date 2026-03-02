#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "Run as root: sudo $0 [username]" >&2
  exit 1
fi

target_user="${1:-${SUDO_USER:-}}"
if [[ -z "${target_user}" ]]; then
  echo "No target user provided. Usage: sudo $0 [username]" >&2
  exit 1
fi

home_dir="$(getent passwd "${target_user}" | cut -d: -f6)"
if [[ -z "${home_dir}" || ! -d "${home_dir}" ]]; then
  echo "Could not resolve home directory for user '${target_user}'." >&2
  exit 1
fi

session_id="home-manager-i3"
desktop_dir="/usr/local/share/xsessions"
desktop_file="${desktop_dir}/${session_id}.desktop"

install -d -m 0755 "${desktop_dir}"
cat > "${desktop_file}" <<EOF
[Desktop Entry]
Name=Home Manager i3
Comment=i3 session launched through ~/.xsession
Exec=/bin/sh ${home_dir}/.xsession
TryExec=${home_dir}/.xsession
Type=Application
DesktopNames=i3
EOF
chmod 0644 "${desktop_file}"

accounts_service_dir="/var/lib/AccountsService/users"
accounts_service_file="${accounts_service_dir}/${target_user}"
tmp_file="$(mktemp)"
tmp_new_file="${tmp_file}.new"
trap 'rm -f "${tmp_file}" "${tmp_new_file}"' EXIT

if [[ -f "${accounts_service_file}" ]]; then
  cat "${accounts_service_file}" > "${tmp_file}"
else
  : > "${tmp_file}"
fi

if grep -q '^XSession=' "${tmp_file}"; then
  sed -i "s|^XSession=.*|XSession=${session_id}|" "${tmp_file}"
elif grep -q '^\[User\]' "${tmp_file}"; then
  awk -v session="${session_id}" '
    /^\[User\]$/ && !inserted {
      print
      print "XSession=" session
      inserted = 1
      next
    }
    { print }
    END {
      if (!inserted) {
        print "[User]"
        print "XSession=" session
      }
    }
  ' "${tmp_file}" > "${tmp_new_file}"
  mv "${tmp_new_file}" "${tmp_file}"
else
  {
    if [[ -s "${tmp_file}" ]]; then
      cat "${tmp_file}"
    fi
    echo "[User]"
    echo "XSession=${session_id}"
  } > "${tmp_new_file}"
  mv "${tmp_new_file}" "${tmp_file}"
fi

install -d -m 0700 "${accounts_service_dir}"
install -m 0600 "${tmp_file}" "${accounts_service_file}"

echo "Installed ${desktop_file}"
echo "Set ${accounts_service_file} -> XSession=${session_id}"
echo "Log out and pick 'Home Manager i3' from the gear menu if needed."
