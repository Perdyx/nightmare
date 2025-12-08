# Author: Per
# Description: Customized Kali Linux image with pre-installed tools for reconnaissance and web application security testing.

FROM kalilinux/kali-rolling:latest


########## Setup environment ##########

# Use bash as default shell for all RUN commands and for image users
SHELL ["/bin/bash", "-lc"]

# Silence the default Kali welcome message
RUN touch /root/.hushlogin

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    GOPATH=/root/go \
    GOBIN=/usr/local/bin \
    GO111MODULE=on \
    PATH=/root/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Set working directory
WORKDIR /root

# Update and upgrade the system
RUN apt update -y
RUN apt upgrade -y


########## Tmux ##########

# Install tmux
RUN apt-get install -y --no-install-recommends tmux

# Display welcome message on tmux shell startup
RUN cat >> /root/.bashrc <<'EOF'
########## Tmux startup script ##########
GREEN=$'\e[1;32m'
RESET=$'\e[0m'

# Fix tmux font rendering issues
export LANG=en_US.UTF-8

# Autostart or attach to a tmux session on shell startup, if not already in one
if [[ -z "$TMUX" ]] && [[ -n "$PS1" ]] && [[ "$(tty)" == "/dev/pts/"* ]]; then
    tmux attach || tmux
fi

if [[ -n "$TMUX" && $- == *i* ]]; then
    # Display connection info
    # echo -e "\n[${GREEN} $(curl -s ipinfo.io/ip) ${RESET}] - $(curl -s ipinfo.io/org)"
    # echo -e "$(curl -s ipinfo.io/city), $(curl -s ipinfo.io/region), $(curl -s ipinfo.io/country)\n"
		
		tmux ls
    echo -e "\nHappy hacking!"
fi
EOF

# Simplify the BASH prompt
RUN sed -i 's/PROMPT_ALTERNATIVE=twoline/PROMPT_ALTERNATIVE=backtrack/g' /root/.bashrc

# Customize tmux
COPY ./tmux.conf /root/.tmux.conf


########## OpenSSH Server ##########

# Install OpenSSH server
RUN apt-get install -y --no-install-recommends openssh-server

# Create SSH directory and set permissions
RUN mkdir -p /var/run/sshd
RUN chmod 0755 /var/run/sshd

# Allow root login and set root password (change 'toor' to a strong password)
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo "root:kaliguard" | chpasswd

# Expose SSH port and change it to a non-standard port
EXPOSE 22


########## Install Base Packages ##########

# Install base packages and tools
RUN apt-get install -y --fix-missing --no-install-recommends \
    sudo \
    software-properties-common \
    amass \
    automake \
    autoconf \
    binutils \
    binwalk \
    build-essential \
    crackmapexec \
    cmake \
    chromium \
    chromium-driver \
    curl \
    dirb \
    dirsearch \
    dnsenum \
    exiftool \
    fierce \
    ffuf \
    feroxbuster \
    git \
    gnupg \
    hashcat \
    hydra \
    john \
    jq \
    less \
    libffi-dev \
    libssl-dev \
    libtool \
    locales \
    lsb-release \
    masscan \
    massdns \
    medusa \
    nano \
    nmap \
    nikto \
    openjdk-11-jdk \
    pkg-config \
    patator \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-venv \
    radare2 \
    responder \
    smbmap \
    steghide \
    foremost \
    theharvester \
    tzdata \
    vim \
    wget \
    wpscan \
    zip \
    kali-linux-headless

# Install pipx
RUN apt install -y pipx
RUN pipx ensurepath --global

# Add pipx packages to path
ENV PATH="/root/.local/bin:${PATH}"
 
# Install Python packages
RUN pipx install \
    kube-hunter \
    prowler \
    ScoutSuite \
    sqlmap \
    volatility3

# Install Ruby gems
RUN apt install -y ruby-dev
RUN gem install --no-document wpscan evil-winrm

# Install specialized tools
RUN apt-get update && apt-get install -y feroxbuster || \
    (mkdir -p /opt/feroxbuster && \
     curl -L -o /opt/feroxbuster/feroxbuster.zip "https://github.com/epi052/feroxbuster/releases/latest/download/feroxbuster-linux-x86_64.zip" && \
     unzip /opt/feroxbuster/feroxbuster.zip -d /opt/feroxbuster && \
     mv /opt/feroxbuster/feroxbuster /usr/local/bin/feroxbuster)

# Install dirsearch
RUN git clone https://github.com/maurosoria/dirsearch.git /opt/dirsearch && \
    python3 -m venv /opt/dirsearch/venv && \
    /opt/dirsearch/venv/bin/pip install --no-cache-dir -r /opt/dirsearch/requirements.txt && \
    ln -s /opt/dirsearch/dirsearch.py /usr/local/bin/dirsearch


########## Golang ##########

# Install Golang using packaged golang-go for easier maintenance and some helpers
RUN apt-get install -y --no-install-recommends golang-go
RUN mkdir -p /root/go
RUN mkdir -p /opt/tools
RUN chown -R root:root /opt/tools
RUN go env -w GO111MODULE=on
RUN go env -w GOPROXY=direct

# Install Golang-based tools
RUN go install -v github.com/tomnomnom/anew@latest
RUN go install -v github.com/tomnomnom/assetfinder@latest
RUN go install -v github.com/tomnomnom/httprobe@latest
RUN go install -v github.com/tomnomnom/waybackurls@latest

RUN go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
RUN go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# Temporary fix to make nuclei install work
RUN apt install -y nuclei
#RUN go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

RUN go install -v github.com/ffuf/ffuf/v2@latest
RUN go install -v github.com/lc/gau/v2/cmd/gau@latest
RUN go install -v github.com/jaeles-project/gospider@latest
RUN go install -v github.com/d3mondev/puredns/v2@latest
RUN go install -v github.com/PentestPad/subzy@latest
RUN go install -v github.com/sensepost/gowitness@latest


########## HexStrike and MCPO ##########

# Install https://github.com/open-webui/mcpo
RUN pipx install mcpo

# Install HexStrike AI
RUN git clone https://github.com/0x4m4/hexstrike-ai.git /opt/hexstrike-ai && \
    python3 -m venv /opt/hexstrike-ai/hexstrike-env && \
    /opt/hexstrike-ai/hexstrike-env/bin/pip install --no-cache-dir -r /opt/hexstrike-ai/requirements.txt

# Add VS Code integration for HexStrike
RUN mkdir /.vscode
COPY ./vscode/mcp.json /.vscode/mcp.json
COPY ./vscode/settings.json /.vscode/settings.json
RUN mkdir -p /.github/agents
COPY ./vscode/Hexstrike.agent.md /.github/agents/Hexstrike.agent.md


########## Image Optimizations and Cleanup ##########

# Clean up apt caches and temporary files to keep image smaller
RUN apt-get autoremove -y
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN history -c


########## Entrypoint ##########

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
