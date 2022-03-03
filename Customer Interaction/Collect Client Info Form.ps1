## Run as: Logged In User
## Max Script Time: 10 Minutes
## This form can be used to collect a clients Name, E-mail address, and phone number and add them under custom assets. 
## Requires the following text fields in custom asset types "Client Phone", "Client E-mail", and "Client Name". 
## The name of the service and the support E-mail are entered as runtime variables. Anything too long may mess with the spacing, so test it out first. 
## Once the user submits (or if it times out) it creates a RMM alert for your team to review.

Import-Module $env:SyncroModule

$ServiceName="YOUR_AGENT_SOFTWARE_NAME"
$SupportEmail="YOUR_SUPPORT_EMAIL_ADDRESS"

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$PCPLiteForm                     = New-Object system.Windows.Forms.Form
$PCPLiteForm.ClientSize          = '530,330'
$PCPLiteForm.text                = "$ServiceName Registration"
$PCPLiteForm.TopMost    = $True
$PCPLiteForm.ControlBox = $False

$btncontinue                     = New-Object system.Windows.Forms.Button
$btncontinue.text                = "Continue"
$btncontinue.width               = 280
$btncontinue.height              = 30
$btncontinue.location            = New-Object System.Drawing.Point(143,210)
$btncontinue.Font                = 'Microsoft Sans Serif,10'

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "Please complete this form to register this PC to your account"
$Label1.BackColor                = "transparent"
$Label1.AutoSize                 = $true
$Label1.visible                  = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(54,64)
$Label1.Font                     = 'Microsoft Sans Serif,12'

$Label2                          = New-Object system.Windows.Forms.Label
$Label2.text                     = "User"
$Label2.AutoSize                 = $true
$Label2.width                    = 25
$Label2.height                   = 10
$Label2.location                 = New-Object System.Drawing.Point(29,107)
$Label2.Font                     = 'Microsoft Sans Serif,10'

$Label3                          = New-Object system.Windows.Forms.Label
$Label3.text                     = "E-mail"
$Label3.AutoSize                 = $true
$Label3.width                    = 25
$Label3.height                   = 10
$Label3.location                 = New-Object System.Drawing.Point(29,138)
$Label3.Font                     = 'Microsoft Sans Serif,10'

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.width                  = 390
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(93,103)
$TextBox1.Font                   = 'Microsoft Sans Serif,10'

$TextBox2                        = New-Object system.Windows.Forms.TextBox
$TextBox2.multiline              = $false
$TextBox2.width                  = 389
$TextBox2.height                 = 20
$TextBox2.location               = New-Object System.Drawing.Point(93,134)
$TextBox2.Font                   = 'Microsoft Sans Serif,10'

$Label4                          = New-Object system.Windows.Forms.Label
$Label4.text                     = "Phone"
$Label4.AutoSize                 = $true
$Label4.width                    = 25
$Label4.height                   = 10
$Label4.location                 = New-Object System.Drawing.Point(29,169)
$Label4.Font                     = 'Microsoft Sans Serif,10'

$TextBox3                        = New-Object system.Windows.Forms.TextBox
$TextBox3.multiline              = $false
$TextBox3.width                  = 389
$TextBox3.height                 = 20
$TextBox3.location               = New-Object System.Drawing.Point(93,164)
$TextBox3.Font                   = 'Microsoft Sans Serif,10'

$Label5                          = New-Object system.Windows.Forms.Label
$Label5.text                     = "$ServiceName"
$Label5.AutoSize                 = $true
$Label5.width                    = 25
$Label5.height                   = 10
$Label5.location                 = New-Object System.Drawing.Point(130,22)
$Label5.Font                     = 'Microsoft Sans Serif,22'

$Label6                          = New-Object system.Windows.Forms.Label
$Label6.text                     = "                                  Data will be verified.`n Missing or incomplete data will cause you to be prompted again. `n  Questions or concerns? Please E-mail $SupportEmail"
$Label6.AutoSize                 = $true
$Label6.width                    = 400
$Label6.height                   = 300
$Label6.location                 = New-Object System.Drawing.Point(80,270)
$Label6.Font                     = 'Microsoft Sans Serif,10'

$PCPLiteForm.controls.AddRange(@($btncontinue,$Label1,$Label2,$Label3,$TextBox1,$TextBox2,$Label4,$TextBox3,$Label5,$Label6))


$btncontinue.Add_Click({ post })

function post {
    
    write-host $TextBox1.text $TextBox2.text $TextBox3.text $hostname
    Set-Asset-Field -Name "Contact Name" -Value $TextBox1.text
	Set-Asset-Field -Name "Contact E-mail" -Value $TextBox2.text
	Set-Asset-Field -Name "Contact Phone" -Value $TextBox3.text
#    Display-Alert -Message "Thank you, your registration information has been submitted and will be reviewed."
    Rmm-Alert -Category 'Registration' -Body 'New Asset Client Info Form completed. Please review the details'
    $PCPLiteForm.Close()
    Display-Alert -Message "Thank you, your registration information has been submitted and will be reviewed."
}





[void]$PCPLiteForm.ShowDialog()
