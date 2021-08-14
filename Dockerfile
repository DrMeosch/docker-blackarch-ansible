FROM archlinux:latest
ENV TERM xterm
COPY ./pacman.conf /etc/pacman.conf
COPY ./sudoers /etc/sudoers
COPY ./entrypoint.sh /
ENV USER_ID 1000
ENV GROUP_ID 1000
RUN pacman --sync --refresh --sysupgrade --noconfirm sudo && \
curl --silent --show-error --output ./strap.sh https://blackarch.org/strap.sh && \
chmod 755 ./strap.sh && \
./strap.sh && \
rm ./strap.sh && \
find / -type f '(' -name '*.pacnew' -or -name '*.pacsave' ')' -delete 2> /dev/null && \
chmod 440 /etc/sudoers && \
groupadd --gid $GROUP_ID devops && \
useradd --uid $USER_ID --gid $GROUP_ID --groups wheel --create-home devops
RUN pacman --noconfirm -S python python-pip \
 && pip3 install ansible
# install more tools
RUN pacman --noconfirm -S subfinder amass assetfinder sublist3r wget curl
RUN wget https://raw.githubusercontent.com/janmasarik/resolvers/master/resolvers.txt -O /home/devops/resolvers.txt
RUN wget https://github.com/danielmiessler/SecLists/raw/master/Discovery/DNS/deepmagic.com-prefixes-top50000.txt -O /home/devops/deepmagic.com-prefixes-top50000.txt
# RUN pacman --noconfirm -S httpx nuclei git
RUN pacman --noconfirm -S httpx git go
RUN wget https://github.com/projectdiscovery/nuclei/releases/download/v2.2.0/nuclei_2.2.0_linux_amd64.tar.gz && tar -C /usr/bin -zxvf nuclei_2.2.0_linux_amd64.tar.gz nuclei && chmod 755 /usr/bin/nuclei
WORKDIR /home/devops
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash", "-i"]
