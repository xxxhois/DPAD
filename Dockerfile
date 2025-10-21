
FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

# 设置非交互模式
ENV DEBIAN_FRONTEND=noninteractive

# 安装 Python 3.11（Ubuntu 22.04 官方源已包含）
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.11 \
        python3.11-dev \
        python3.11-venv \
        python3-pip \
        git \
        build-essential \
        && rm -rf /var/lib/apt/lists/*

# 设置默认 python3 为 3.11
RUN ln -sf /usr/bin/python3.11 /usr/bin/python3

# 设置工作目录
WORKDIR /app

# 复制代码
COPY . .

# 安装 DPAD 所需依赖（严格按你提供的版本）
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

# 验证 GPU 可用性（构建时会打印）
RUN python3 -c "import tensorflow as tf; print('GPU devices:', tf.config.list_physical_devices('GPU')); print('TensorFlow version:', tf.__version__)"

# 暴露 Jupyter 端口
EXPOSE 8888

# 启动 Jupyter Notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]

