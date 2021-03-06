#https://developer.atlassian.com/cloud/confluence/rest/#api-content-id-history-version-macro-id-macroId-get
function Invoke-ConfluenceGetContentLabels {
    [CmdletBinding()]
    param (
        # The id of the content
        [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [int32]
        $ContentId,

        # The scope/prefix of the labels to be returned
        [Parameter(Position=1,ValueFromPipelineByPropertyName)]
        [Alias("Prefix")]
        [ValidateSet("global","my","team")]
        [string]
        $Scope,

        # The index of the first item to return in the page of results (page offset). The base index is 0.
        [Parameter(Position=2)]
        [int32]
        $StartAt=0,

        # The maximum number of items to return per page. The default is 200 and the maximum is 200.
        [Parameter(Position=3)]
        [ValidateRange(1,200)]
        [int32]
        $MaxResults=200,

        # The AtlassianContext object to use for the request (use New-AtlassianContext)
        [Parameter()]
        [object]
        $RequestContext
    )
    begin {
        $results = @()
    }
    process {
        $functionPath = "/wiki/rest/api/content/$ContentId/label"
        $verb = "GET"

        $query = New-PACRestMethodQueryParams @{
            start = $StartAt
            limit = $MaxResults
        }
        if($PSBoundParameters.ContainsKey("Scope")){$query.Add("prefix",$Scope)}

        $method = New-PACRestMethod $functionPath $verb $query
        $results += $method.Invoke($RequestContext)
    }
    end {
        $results
    }
}
