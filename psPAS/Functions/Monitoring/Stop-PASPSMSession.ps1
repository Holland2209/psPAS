function Stop-PASPSMSession {
	<#
.SYNOPSIS
Terminates a Live PSM Session.

.DESCRIPTION
Terminates a Live PSM Session identified by the unique ID of the PSM Session.

.PARAMETER LiveSessionId
The unique ID/SessionGuid of a Live PSM Session.

.EXAMPLE
Stop-PASPSMSession -LiveSessionId $SessionUUID

Terminates Live PSM Session identified by the session UUID.

.INPUTS
All parameters can be piped by property name

.NOTES
Minimum CyberArk Version 10.1

.LINK
https://pspas.pspete.dev/commands/Stop-PASPSMSession
#>
	[CmdletBinding(SupportsShouldProcess)]
	param(
		[parameter(
			Mandatory = $true,
			ValueFromPipelinebyPropertyName = $true
		)]
		[ValidateNotNullOrEmpty()]
		[Alias("SessionGuid")]
		[string]$LiveSessionId
	)

	BEGIN {
		Assert-VersionRequirement -RequiredVersion 10.1
	}#begin

	PROCESS {

		#Create URL for Request
		$URI = "$Script:BaseURI/api/LiveSessions/$($LiveSessionId | Get-EscapedString)/Terminate"

		if ($PSCmdlet.ShouldProcess($LiveSessionId, "Terminate PSM Session")) {

			#send request to PAS web service
			Invoke-PASRestMethod -Uri $URI -Method POST -WebSession $Script:WebSession

		}

	} #process

	END { }#end

}