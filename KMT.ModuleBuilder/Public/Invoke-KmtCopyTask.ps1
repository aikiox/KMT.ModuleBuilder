function Invoke-KmtCopyTask
{
    <#
        .Synopsis
        Copy module files and structure into build output

        .Example
        Invoke-KmtCopyTask

        .Notes

    #>
    [cmdletbinding()]
    param(

    )

    begin
    {

    }

    end
    {
        try
        {
            $source = (Get-KmtBuildVariable).Source
    $destination = (Get-KmtBuildVariable).Destination
    $moduleName = (Get-KmtBuildVariable).ModuleName
    $buildRoot = (Get-KmtBuildVariable).BuildRoot
    $folders = (Get-KmtBuildVariable).Folders

    "Creating Directory [$Destination]..."
    $null = New-Item -ItemType 'Directory' -Path $Destination -ErrorAction 'Ignore'

    $files = Get-ChildItem -Path $Source -File |
        Where-Object 'Name' -notmatch "$ModuleName\.ps[dm]1"

    foreach ($file in $files)
    {
        'Creating [.{0}]...' -f $file.FullName.Replace($buildroot, '')
        Copy-Item -Path $file.FullName -Destination $Destination -Force
    }

    $directories = Get-ChildItem -Path $Source -Directory |
        Where-Object 'Name' -notin $Folders

    foreach ($directory in $directories)
    {
        'Creating [.{0}]...' -f $directory.FullName.Replace($buildroot, '')
        Copy-Item -Path $directory.FullName -Destination $Destination -Recurse -Force
    }

    $license = Join-Path -Path $buildroot -ChildPath 'LICENSE'
    if ( Test-Path -Path $license -PathType Leaf )
    {
        Copy-Item -Path $license -Destination $Destination
    }
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSItem )
        }
    }
}