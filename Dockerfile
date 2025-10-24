# 改为 devel 镜像
FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# 安装 Python 3.11、常用开发工具、SSH、sudo 等
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
        tzdata \
        && rm -rf /var/lib/apt/lists/*

# 启用 SSH 服务目录
RUN mkdir -p /run/sshd

# 设置 python3 默认版本
RUN ln -sf /usr/bin/python3.11 /usr/bin/python3 && \
    ln -sf /usr/bin/pip3 /usr/bin/pip

# 工作目录
WORKDIR /app

# 复制当前目录代码到镜像中
COPY . .

# 安装 Python 库与 Jupyter
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir \
        jupyter \
        notebook \
        tensorflow==2.15.1 \
        numpy==1.26.4 \
        sympy==1.13.2 \
        ipython \
        ipykernel \
        PSID==1.2.5 \
        coloredlogs==15.0.1 \
        tqdm==4.66.4 \
        xxhash==3.5.0 && \
    python3 -m ipykernel install --name=python3 --display-name "Python 3 (CUDA 12.1)" && \
    jupyter notebook --generate-config && \
    rm -rf /root/.cache/pip

# 暴露 Jupyter 和 SSH 端口
EXPOSE 8888 22


