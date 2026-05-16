# Build a Pillow AWS Lambda Layer (prebuilt on Amazon Linux)

This repo adds scripts to build a Pillow-based Lambda layer zip compatible with AWS Lambda Python runtimes.

Files added:
- `build_layer.sh` — Linux/macOS script using Docker.
- `build_layer.ps1` — PowerShell script for Windows using Docker.
- `requirements.txt` — pins `Pillow==9.5.0`.

How to build (Linux/macOS):

```bash
# from repository root
./build_layer.sh 3.9
# or for Python 3.8: ./build_layer.sh 3.8
```

How to build (Windows PowerShell):

```powershell
# from repository root
./build_layer.ps1 -PythonVersion 3.9
```

What the scripts do:
- Run a Docker image that matches the Lambda build environment (`lambci/lambda:build-pythonX.Y`).
- Install `Pillow` into a local `python/` folder.
- Zip the `python/` folder to `pillow_layer_pyX.Y.zip` — this is the artifact to upload as a Lambda Layer.

Notes:
- You must have Docker installed and running. The produced wheel/binaries will be compatible with AWS Lambda's Amazon Linux when built inside the `lambci` image.
- Choose the Python version to match your Lambda runtime (3.8, 3.9, 3.10, etc.).
- If you need additional packages (e.g., numpy), add them to `requirements.txt` before running the build.

Uploading to AWS Lambda:

1. Go to the AWS Console → Lambda → Layers → Create layer.
2. Upload the `pillow_layer_pyX.Y.zip` file.
3. Choose the compatible runtimes (Python X.Y).
4. Add the layer to your function and test.
