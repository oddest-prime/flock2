
export CUDA_PATH=/usr/local/cuda-12.1
export CUDA_ARCH=60
# export LINUX_DEBUG

cmake CMakeLists.txt \
    -DLIBMIN_ROOT=../libmin \
    -Bbuild \
    -DBUILD_CUDA=true \
    -DBUILD_OPENGL=true \
    -DBUILD_GLEW=true

make -Cbuild
