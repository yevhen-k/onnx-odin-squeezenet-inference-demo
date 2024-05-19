ONNXRUNTIME_VERSION := "1.17.3"

echo:
    echo {{ONNXRUNTIME_VERSION}} 

download-onnx:
    #!/usr/bin/env bash
    set -xeu
    curl https://github.com/microsoft/onnxruntime/releases/download/v{{ONNXRUNTIME_VERSION}}/onnxruntime-linux-x64-gpu-cuda12-{{ONNXRUNTIME_VERSION}}.tgz -Lso onnxruntime-linux-x64-gpu-cuda12-{{ONNXRUNTIME_VERSION}}.tgz
    tar -xvf onnxruntime-linux-x64-gpu-cuda12-{{ONNXRUNTIME_VERSION}}.tgz
    mv onnxruntime-linux-x64-gpu-{{ONNXRUNTIME_VERSION}} /thirdparty/onnxruntime
    rm -f onnxruntime-linux-x64-gpu-cuda12-{{ONNXRUNTIME_VERSION}}.tgz

get-bindings:
    #!/usr/bin/env bash
    set -xeu
    curl https://raw.githubusercontent.com/yevhen-k/onnx-odin-bindings/ONNX-{{ONNXRUNTIME_VERSION}}_OdinLinux-0.0.1/onnxbinding.odin -Lso onnxbinding.odin

get-model:
    curl https://github.com/onnx/models/raw/main/validated/vision/classification/squeezenet/model/squeezenet1.0-8.onnx -Lso squeezenet1.0-8.onnx

build:
    #!/usr/bin/env bash
    cd ..
    odin build onnx-odin-squeezenet-inference-demo -extra-linker-flags:"-Wl,-rpath=/thirdparty/onnxruntime/lib/" -out:onnx-odin-squeezenet-inference-demo/odin_onnx_example

run: build
    ./odin_onnx_example