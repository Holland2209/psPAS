function Unblock-PASUser {
	<#
.SYNOPSIS
Activates a suspended user

.DESCRIPTION
Activates an existing vault user who was suspended due to password failures.

.PARAMETER id
 The user's unique ID
Requires CyberArk version 10.10+

.PARAMETER UserName
The user's name

.PARAMETER Suspended
Suspension status

.EXAMPLE
Unblock-PASUser -UserName MrFatFingers -Suspended $false

Activates suspended vault user MrFatFingers using the Classic API

.EXAMPLE
Unblock-PASUser -id 666

Activates suspended vault user with id 666, using the API from 10.10+

.LINK
https://pspas.pspete.dev/commands/Unblock-PASUser
#>
	[CmdletBinding(DefaultParameterSetName = "10.10")]
	param(
		[parameter(
			Mandatory = $true,
			ValueFromPipelinebyPropertyName = $true,
			ParameterSetName = "10.10"
		)]
		[int]$id,

		[parameter(
			Mandatory = $true,
			ValueFromPipelinebyPropertyName = $true,
			ParameterSetName = "ClassicAPI"
		)]
		[string]$UserName,

		[parameter(
			Mandatory = $true,
			ValueFromPipelinebyPropertyName = $false,
			ParameterSetName = "ClassicAPI"
		)]
		[ValidateSet($false)]
		[boolean]$Suspended
	)

	BEGIN {

		$Request = @{"WebSession" = $Script:WebSession }

	}#begin

	PROCESS {

		switch ($PSCmdlet.ParameterSetName) {

			"10.10" {

				Assert-VersionRequirement -RequiredVersion $PSCmdlet.ParameterSetName

				#Create request
				$Request["URI"] = "$Script:BaseURI/api/Users/$id/Activate"
				$Request["Method"] = "POST"

				break

			}

			"ClassicAPI" {

				#Create request
				$Request["URI"] = "$Script:BaseURI/WebServices/PIMServices.svc/Users/$($UserName | Get-EscapedString)"
				$Request["Method"] = "PUT"
				$Request["Body"] = $PSBoundParameters | Get-PASParameter -ParametersToRemove UserName | ConvertTo-Json

				break

			}
		}

		#send request to web service
		$result = Invoke-PASRestMethod @Request

		If ($null -ne $result) {

			$result | Add-ObjectDetail -typename psPAS.CyberArk.Vault.User

		}

	}#process

	END { }#end

}