##
# VARIABLES
##

# Prompt user for remote computer's hostname, user, and group
$REMOTE_PC = Read-Host "Remote hostname"
$REMOTE_GROUP = Read-Host "Group name to edit (i.e. Administrators)"
$REMOTE_USER = Read-Host "Username to add/remove from", $REMOTE_GROUP

##
# FUNCTIONS
##

function Add-UserGroup {
    Write-Host "Adding", $REMOTE_USER, "to", $REMOTE_GROUP, "on", $REMOTE_PC

    Invoke-Command -ComputerName $REMOTE_PC -ScriptBlock {
        Add-LocalGroupMember -Group $REMOTE_GROUP -Member $REMOTE_USER
    }
}

function Remove-UserGroup {
    Write-Host "Removing", $REMOTE_USER, "from", $REMOTE_GROUP, "on", $REMOTE_PC

    Invoke-Command -ComputerName $REMOTE_PC -ScriptBlock {
        Remove-LocalGroupMember -Group $REMOTE_GROUP -Member $REMOTE_USER
    }
}

##
# PROMPT
##

$PROMPT_ADD = New-Object System.Management.Automation.Host.ChoiceDescription "&Add", "Description."
$PROMPT_REMOVE = New-Object System.Management.Automation.Host.ChoiceDescription "&Remove", "Description."
$CHOICES = [System.Management.Automation.Host.ChoiceDescription[]]($PROMPT_ADD, $PROMPT_REMOVE)

# Title for prompt
$PROMPT_TITLE = "Add/Remove user to/from group"
# Message to prompt user for input
$PROMPT_MESSAGE = "Are you Adding or Removing a user?"
$PROMPT_RESPONSE = $Host.UI.PromptForChoice($PROMPT_TITLE, $PROMPT_MESSAGE, $CHOICES, 1)

# Switch statement based on prompt choice
switch ($PROMPT_RESPONSE) {
    0 {
        # User selected "Add"
        Add-UserGroup
    } 1 {
        # User selected "Remove"
        Remove-UserGroup
    }
}
