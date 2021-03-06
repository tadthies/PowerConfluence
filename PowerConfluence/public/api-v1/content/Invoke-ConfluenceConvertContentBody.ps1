$ConfluenceContentExpand = @("childTypes.all","childTypes.attachment","childTypes.comment","childTypes.page",
                             "container","metadata.currentuser","metadata.properties","metadata.labels",
                             "metadata.frontend","operations","children.page","children.attachment","children.comment",
                             "restrictions.read.restrictions.user","restrictions.read.restrictions.group",
                             "restrictions.update.restrictions.user","restrictions.update.restrictions.group",
                             "history","history.lastUpdated","history.previousVersion","history.contributors",
                             "history.nextVersion","ancestors","body","version","descendants.page",
                             "descendants.attachment","descendants.comment","space")

#https://developer.atlassian.com/cloud/confluence/rest/#api-contentbody-convert-to-post
function Invoke-ConfluenceConvertContentBody {
    [CmdletBinding(DefaultParameterSetName="ContentContext")]
    param (
        # The content to be converted
        [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string]
        $ContentBody,

        # The current formt of the content
        [Parameter(Mandatory,Position=1,ValueFromPipelineByPropertyName)]
        [Alias("From")]
        [string]
        $FromFormat,

        # The format to convert to
        [Parameter(Mandatory,Position=1,ValueFromPipelineByPropertyName)]
        [Alias("To")]
        [string]
        $ToFormat,

        # Space key to set the context for converting embedded content
        [Parameter(Position=2,ValueFromPipelineByPropertyName,ParameterSetName="SpaceContext")]
        [string]
        $SpaceKey,

        # The ID of the content to set the context for converting embedded content
        [Parameter(Position=2,ValueFromPipelineByPropertyName,ParameterSetName="ContentContext")]
        [string]
        $ContentId,

        [Parameter(Position=3,ValueFromPipelineByPropertyName)]
        [ValidateScript({ Compare-StringArraySubset $ConfluenceContentExpand $_ })]
        [string[]]
        $Expand,

        # Set this flag to render embeded contents as the version they were when the content was saved
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $EmbedRenderAtSave,

        # The AtlassianContext object to use for the request (use New-AtlassianContext)
        [Parameter()]
        [object]
        $RequestContext
    )
    begin {
        $results = @()
    }
    process {
        $functionPath = "/wiki/rest/api/contentbody/convert/$ToFormat"
        $verb = "POST"

        $query = New-PACRestMethodQueryParams @{
            embeddedContentRender = IIF $EmbedRenderAtSave "version-at-save" "current"
        }
        $body = New-PACRestMethodJsonBody @{
            value = $ContentBody
            representation = $FromFormat
        }
        if($PSBoundParameters.ContainsKey("Expand")){$query.Add("expand",$Expand -join ",")}
        if($PSBoundParameters.ContainsKey("SpaceKey")){$query.Add("spaceKeyContext",$SpaceKey)}
        if($PSBoundParameters.ContainsKey("ContentId")){$query.Add("contentIdContext",$ContentId)}

        $method = New-PACRestMethod $functionPath $verb $query $body
        $results += $method.Invoke($RequestContext)
    }
    end {
        $results
    }
}