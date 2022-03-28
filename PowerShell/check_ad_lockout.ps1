##
# Check an AD account (by username) for lockout status
#
# TODO:
#  - Allow passing username as flag
#  - Auto-unlock account if locked
#
# https://specopssoft.com/blog/how-to-check-if-an-ad-account-is-locked-out/
##

Import-Module ActiveDirectory

$CHECK_USER = Read-Host -Prompt 'AD username to check for last login: '

# get-aduser -identity $CHECK_USER -properties * | Select-Object accountexpirationdate, accountexpires, accountlockouttime, badlogoncount, padpwdcount, lastbadpasswordattempt, lastlogondate, lockedout, passwordexpired, passwordlastset, pwdlastset | format-list

net user $CHECK_USER /domain

# Unlock account
# Unlock-ADAccount <username>
