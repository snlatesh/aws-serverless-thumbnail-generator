param(
    [string]$PythonVersion = "3.9"
)

$image = "lambci/lambda:build-python$PythonVersion"
$req = "requirements.txt"
$buildDir = "python"
$output = "pillow_layer_py${PythonVersion}.zip"

Write-Host "Building Pillow layer for Python $PythonVersion using image $image"

if (Test-Path $buildDir) { Remove-Item -Recurse -Force $buildDir }
if (Test-Path $output) { Remove-Item -Force $output }

New-Item -ItemType Directory -Path $buildDir | Out-Null

docker run --rm -v "${PWD}:/var/task" $image /bin/bash -lc "python -m pip install --upgrade pip && pip install -r $req -t $buildDir --upgrade && chmod -R a+r $buildDir"

& zip -r $output $buildDir

Write-Host "Created $output — upload this to Lambda Layers for the matching Python runtime."
