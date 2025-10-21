# 改为 devel 镜像
FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# devel 镜像已包含完整 CUDA 运行时库，但仍需安装 Python 和 ssh/sudo
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.11 \
        python3.11-dev \
        python3.11-venv \
        python3-pip \
        git \
        build-essential \
        sudo \
        openssh-server \
        && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/sshd
RUN ln -sf /usr/bin/python3.11 /usr/bin/python3

WORKDIR /app
COPY . .

RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir \
        tensorflow==2.15.1 \
        numpy==1.26.4 \
        sympy==1.13.2 \
        ipython \
        ipykernel \
        PSID==1.2.5 \
        coloredlogs==15.0.1 \
        tqdm==4.66.4 \
        xxhash==3.5.0

EXPOSE 8888 22
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
