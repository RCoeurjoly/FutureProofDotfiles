#!/bin/sh

# Make startx use the same Home Manager-managed session script as display managers.
exec /bin/sh "$HOME/.xsession"
