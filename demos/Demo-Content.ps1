#import PowerConfluence
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \..\PowerConfluence\PowerConfluence.psd1) -Force

#import the variable $ConfluenceCredentials
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \credentials\Credentials.psm1) -Force

#open a new Confluence session
Open-ConfluenceSession -UserName $ConfluenceCredentials.UserName -Password $ConfluenceCredentials.ApiToken -HostName $ConfluenceCredentials.HostName

#do tests here

#ADD LABELS TO CONTENT
#332595201 | Invoke-ConfluenceAddContentLabels -Label "test2"
#@("test3","test4") | Invoke-ConfluenceAddContentLabels 755826903

#GET CONTENT
#Invoke-ConfluenceGetContent "Test Page" "JPT"

#GET CONTENT BY ID
#Invoke-ConfluenceGetContentById 332595201
#@(755826903,747111944) | Invoke-ConfluenceGetContentById

#CREATE CONTENT
#@("auto test 1","auto test 2") | Invoke-ConfluenceCreateContent "JPT" -Body (New-ConfluenceContentBody "")
#Invoke-ConfluenceCreateContent JPT "comment title" (New-ConfluenceContentBody "this is a comment") -Type "comment" -ParentId 17137665

#UPDATE CONTENT
#Invoke-ConfluenceGetContentById 332595201 | ForEach-Object {$_.title += " (Edited)";$_} | Invoke-ConfluenceUpdateContent

#CREATE OR UPDATE ATTACHMENT
#Get-Item $PSScriptRoot\SampleAttachment* | Invoke-ConfluenceCreateOrUpdateAttachment 332595201
#Get-Item $PSScriptRoot\SampleAttachment* | Invoke-ConfluenceCreateOrUpdateAttachment 17137665 -ForceCreate

#DELETE CONTENT
#332595201 | Invoke-ConfluenceDeleteContent

#GET CONTENT CHILDREN
#(Invoke-ConfluenceGetContentChildren 332595201 -Expand "attachment").attachment

#GET CONTENT LABELS
#Invoke-ConfluenceGetContentLabels 332595201

#GET ATTACHMENTS
#Invoke-ConfluenceGetAttachments 332595201

#GET CONTENT COMMENTS
#Invoke-ConfluenceGetContentComments 332595201

#REMOVE CONTENT LABEL
#"test2" | Invoke-ConfluenceRemoveContentLabel 332595201

#CONVERT CONTENT BODY
#Invoke-ConfluenceConvertContentBody "my unwrapped content" -FromFormat "wiki" -ToFormat "storage"
# $content = (Get-Content $PSScriptRoot\markup.txt) -join "" #
# $value = $content -replace [char]0x00a0,'-' | Invoke-ConfluenceConvertContentBody -FromFormat "wiki" -ToFormat "storage"
# $value

#end tests

#close the Confluence session
Close-ConfluenceSession