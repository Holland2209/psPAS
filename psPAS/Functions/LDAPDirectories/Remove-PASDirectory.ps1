function Remove-PASDirectory {
	<#
.SYNOPSIS
Removes an LDAP directory configured in the Vault

.DESCRIPTION
Removes an LDAP directory configuration from the vault.
Membership of the Vault Admins group required.

.PARAMETER id
The ID or Name of the directory to return information on.

.EXAMPLE
Remove-PASDirectory -id LDAPDirectory

Removes LDAP directory configured in the Vault

.INPUTS
WebSession & BaseURI can be piped to the function by propertyname

.OUTPUTS
LDAP Directory Details

.LINK
https://pspas.pspete.dev/commands/Remove-PASDirectory
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param(
		[parameter(
			Mandatory = $true,
			ValueFromPipelinebyPropertyName = $true
		)]
		[Alias("DomainName")]
		[string]$id

	)

	BEGIN {
		Assert-VersionRequirement -RequiredVersion 10.7
	}#begin

	PROCESS {

		#Create URL for request
		$URI = "$Script:BaseURI/api/Configuration/LDAP/Directories/$id"

		if ($PSCmdlet.ShouldProcess($id, "Delete Directory")) {

			#send request to web service
			Invoke-PASRestMethod -Uri $URI -Method DELETE -WebSession $Script:WebSession

		}

	}#process

	END { }#end
}