FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

# 设置非交互模式
ENV DEBIAN_FRONTEND=noninteractive

# 安装 Python 3.11、SSH、sudo 及其他必要工具
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

# 创建 /run/sshd 目录（sshd 启动必需）
RUN mkdir -p /run/sshd

# 设置默认 python3 为 3.11
RUN ln -sf /usr/bin/python3.11 /usr/bin/python3

# 设置工作目录
WORKDIR /app

# 复制代码
COPY . .

# 安装依赖
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

# 验证 GPU
RUN python3 -c "import tensorflow as tf; print('GPU devices:', tf.config.list_physical_devices('GPU')); print('TensorFlow version:', tf.__version__)"

# 暴露端口
EXPOSE 8888 22

# 启动 Jupyter（平台可能会覆盖 CMD，但保留无妨）
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
