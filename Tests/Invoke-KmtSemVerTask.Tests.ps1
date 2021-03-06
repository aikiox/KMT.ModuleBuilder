Describe 'Function Invoke-KmtSemVerTask' -tag build {
    $testCases = @(
        @{
            name='SimpleModule';
            source="$PSScriptRoot/Data/SampleModule/SampleModule";
            reference="$PSScriptRoot/Data/ReferenceOutput/SampleModule/SampleModule.psd1"
            version = '0.1.1'
        }
    )
    It -Pending 'Updates SemVersion for <Name>' -TestCases $testCases {
        param(
            $Name,
            $Source,
            $Reference,
            $Version
        )

        $ManifestPath = Join-Path "TestDrive:" "$Name.psd1"
        New-ModuleManifest -ModuleVersion $version -Path $ManifestPath
        $task = @{
            SourcePath = $source
            ManifestPath = $ManifestPath
            ModuleName = 'SampleModule'
            Repository = 'PSGallery'
        }
        Invoke-KmtSemVerTask @task
        $task.ManifestPath | Should -FileContentMatch ($version)
    }
}
