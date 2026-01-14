# Author: Per
# Description: Customized Kali image for AI-based security testing

FROM kalilinux/kali-rolling:latest

EXPOSE 22
WORKDIR /root

SHELL ["/bin/bash", "-lc"]

ENV \
    DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    GOPATH=/root/go \
    GOBIN=/usr/local/bin \
    PATH=/root/.local/bin:/root/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN touch /root/.hushlogin
RUN sed -i 's/PROMPT_ALTERNATIVE=twoline/PROMPT_ALTERNATIVE=backtrack/g' /root/.bashrc
COPY ./tmux.conf /root/.tmux.conf

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends --fix-missing \
        tmux \
        openssh-server \
        build-essential \
        curl \
        git \
        jq \
        less \
        vim \
        wget \
        zip \
        unzip \
        python3-venv \
        virtualenv \
        python3-pip \
        pipx \
        kali-linux-headless \
        nuclei \
        golang-go && \
    mkdir -p /var/run/sshd && \
    chmod 0755 /var/run/sshd && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo "root:toor" | chpasswd && \
    pipx ensurepath --global && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends golang-go && \
    mkdir -p /root/go /opt/tools && \
    chown -R root:root /opt/tools && \
    go env -w GO111MODULE=on && \
    go env -w GOPROXY=direct && \
    go env -w CGO_ENABLED=1 && \
    go install github.com/tomnomnom/anew@latest && \
    go install github.com/tomnomnom/assetfinder@latest && \
    go install github.com/tomnomnom/gf && \
    go install github.com/tomnomnom/httprobe@latest && \
    go install github.com/tomnomnom/waybackurls@latest && \
    go install github.com/projectdiscovery/httpx/cmd/httpx@latest && \
    go install github.com/projectdiscovery/katana/cmd/katana@latest && \
    go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    go install github.com/projectdiscovery/alterx/cmd/alterx@latest && \
    go install github.com/d3mondev/puredns/v2@latest && \
    go install github.com/ffuf/ffuf/v2@latest && \
    go install github.com/jaeles-project/gospider@latest && \
    go install github.com/lc/gau/v2/cmd/gau@latest && \
    go install github.com/PentestPad/subzy@latest && \
    go install github.com/sensepost/gowitness@latest && \
    go install github.com/hahwul/dalfox/v2@latest

RUN apt-get install -y --no-install-recommends feroxbuster || \
    (mkdir -p /opt/feroxbuster && \
     curl -L -o /opt/feroxbuster/feroxbuster.zip "https://github.com/epi052/feroxbuster/releases/latest/download/feroxbuster-linux-x86_64.zip" && \
     unzip /opt/feroxbuster/feroxbuster.zip -d /opt/feroxbuster && \
     mv /opt/feroxbuster/feroxbuster /usr/local/bin/feroxbuster)

RUN git clone https://github.com/maurosoria/dirsearch.git /opt/dirsearch && \
    python3 -m venv /opt/dirsearch/venv && \
    /opt/dirsearch/venv/bin/pip install --no-cache-dir -r /opt/dirsearch/requirements.txt && \
    ln -s /opt/dirsearch/dirsearch.py /usr/local/bin/dirsearch

RUN git clone https://github.com/u21h2/AutoSpear.git /opt/AutoSpear && \
    python3 -m virtualenv /opt/AutoSpear/spearenv && \
    /opt/AutoSpear/spearenv/bin/pip install --no-cache-dir -r /opt/AutoSpear/requirements.txt && \
    ln -s /opt/AutoSpear/autospear.py /usr/local/bin/autospear

RUN apt-get install -y --no-install-recommends hexstrike-ai

RUN mkdir -p /.vscode
COPY ./mcp.json /.vscode/mcp.json
COPY ./settings.json /.vscode/settings.json
RUN mkdir -p /.github/agents
COPY ./Nightmare.agent.md /.github/agents/Nightmare.agent.md

RUN apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && history -c

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
