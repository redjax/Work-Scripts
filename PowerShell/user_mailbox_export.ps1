# Path to export mailbox/archive to
$ARCHIVE_EXPORT_PATH = "\\path\to\export\dir"
# Get username as input from user
$ARCHIVE_USER = Read-Host "Username for export: "
# Create "username.pst" var
$ARCHIVE_MAILBOX = $ARCHIVE_USER + ".pst"


#######################################
# Prompt for archive enabled/disabled #
#######################################

# Create "Yes" choice for prompt
$ARCHIVE_ENABLED_PROMPT_YES = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
# Create "No" choice for prompt
$ARCHIVE_ENABLED_PROMPT_NO = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
# Build prompt choices array
$CHOICES = [System.Management.Automation.Host.ChoiceDescription[]]($ARCHIVE_ENABLED_PROMPT_YES, $ARCHIVE_ENABLED_PROMPT_NO)

# Title for prompt
$ARCHIVE_ENABLED_PROMPT_TITLE = "User Archive" 
# Message to prompt user for input
$MESSAGE = "Is the user's archive enabled? Check Exchange before answering."
# Variable with prompt's input
$ARCHIVE_ENABLED_PROMPT_RESULT = $Host.UI.PromptForChoice($ARCHIVE_ENABLED_PROMPT_TITLE, $MESSAGE, $CHOICES, 1)

# Switch statement based on prompt choices
switch ($ARCHIVE_ENABLED_PROMPT_RESULT) {
  # Yes, archive enabled
  0 {
    Write-Host "Exporting archive."
    # Run the command for a mailbox with an archive
    New-MailboxExportRequest $ARCHIVE_USER -FilePath $ARCHIVE_EXPORT_PATH\$ARCHIVE_USER.pst -IsArchive
  # No, archive not enabled
  } 1 {
    Write-Host "Exporting mailbox only."
    # Run the command for a mailbox with no archive
    New-MailboxExportRequest $ARCHIVE_USER -FilePath $ARCHIVE_EXPORT_PATH\$ARCHIVE_USER.pst
  }
}


Write-Host "Export finished."
