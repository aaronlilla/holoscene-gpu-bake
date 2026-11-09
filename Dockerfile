# Public open-source tools only. No game code or assets.
FROM runpod/base:2.1.0-ubuntu2404

ENV DEBIAN_FRONTEND=noninteractive \
    RUSTUP_HOME=/opt/rustup CARGO_HOME=/opt/cargo \
    PATH=/opt/cargo/bin:$PATH \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics,display,video

RUN apt-get update && apt-get install -y --no-install-recommends \
      libegl1 libgl1 libglx0 libglvnd0 libgles2 libopengl0 libvulkan1 vulkan-tools mesa-utils \
      xserver-xorg-core xinit x11-utils x11-xserver-utils xauth kmod pciutils \
      dotnet-sdk-8.0 cmake ninja-build clang pkg-config build-essential git curl wget ca-certificates xz-utils \
    && rm -rf /var/lib/apt/lists/*

# node 20 (official tarball; version resolved at build time)
RUN V=$(curl -fsSL https://nodejs.org/dist/latest-v20.x/SHASUMS256.txt | grep -o 'node-v[0-9.]*-linux-x64.tar.xz' | head -1) \
    && curl -fsSL https://nodejs.org/dist/latest-v20.x/$V | tar -xJ -C /usr/local --strip-components=1

# rust stable
RUN curl -fsSL https://sh.rustup.rs | sh -s -- -y --profile minimal --default-toolchain stable \
    && printf 'export RUSTUP_HOME=/opt/rustup CARGO_HOME=/opt/cargo\nexport PATH=/opt/cargo/bin:$PATH\n' > /etc/profile.d/rust.sh

COPY files/holoscene-xorg /usr/local/bin/holoscene-xorg
RUN chmod +x /usr/local/bin/holoscene-xorg \
    && printf 'export DISPLAY=:0\nexport NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics,display,video\n' > /etc/profile.d/disp.sh
