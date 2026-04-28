$SMTPServer = "sandbox.smtp.mailtrap.io"
$SMTPPort = 2525
$Username = "6f13c305dfbd02"
$Password = "aa23b53e20dbc5"
$From = "jkartsupport@gmail.com"
$To = "bardgpttester@gmail.com"
$Subject = "SMTP Test from JNexus Notification Service"
$Body = "This is a test email. If you see this, email is working!"

try {
    $SecurePass = ConvertTo-SecureString $Password -AsPlainText -Force
    $Cred = New-Object System.Management.Automation.PSCredential($Username, $SecurePass)
    Send-MailMessage -SmtpServer $SMTPServer -Port $SMTPPort -Credential $Cred -From $From -To $To -Subject $Subject -Body $Body -ErrorAction Stop
    Write-Host "SUCCESS: Email sent! Check Mailtrap inbox." -ForegroundColor Green
} catch {
    Write-Host "FAILED:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow
}
