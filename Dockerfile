# 基础镜像：Python 3.11 + CUDA（若无需GPU可换为非CUDA版本）
FROM registry.cn-hangzhou.aliyuncs.com/nvidia/cuda:12.3.1-cudnn8-runtime-ubuntu22.04

# 设置非交互模式
ENV DEBIAN_FRONTEND=noninteractive

# 安装基础工具
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.11 python3.11-distutils python3-pip python3-venv git wget curl && \
    rm -rf /var/lib/apt/lists/*

# 默认 python 指向 3.11
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1

# 升级 pip
RUN python -m pip install --upgrade pip

# 安装依赖
RUN pip install \
    tensorflow==2.15.1 \
    numpy==1.26.4 \
    sympy==1.13.2 \
    ipython \
    ipykernel \
    PSID==1.2.5 \
    coloredlogs==15.0.1 \
    tqdm==4.66.4 \
    xxhash==3.5.0

# Jupyter Notebook 默认端口
EXPOSE 8888

# 启动容器默认工作目录
WORKDIR /workspace

# 创建一个 Jupyter 内核，避免你之后手动添加
RUN python -m ipykernel install --name py311 --display-name "Python 3.11 (Project)"

# 启动命令（你也可以在平台上改为命令行方式运行）
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]

