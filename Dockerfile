FROM jgoerzen/debian-base-security:latest
LABEL maintainer="gfa@zumbi.com.ar"

ENV DEBIAN_FRONTEND noninteractive
ARG username
ARG repository
ARG yadm_user
ARG yadm_pass
ARG yadm_host
ARG mailname

RUN \
  apt update && \
  apt autoremove -y --purge exim4-config exim4-daemon-light exim4-base \
  zsh+ yadm+ python3-pip+ virtualenv+ python3-virtualenv+ git+ \
  locales-all+ neomutt+ neovim+ nullmailer+ direnv+ bsd-mailx+ pass+ vdirsyncer+ \
  neomutt+ neovim+ nullmailer+ direnv+ bsd-mailx+ pass+ isync+ notmuch+ lbdb+ \
  khard+ khal+ w3m+

RUN \
  pip3 install envtpl

RUN \
  rm /usr/local/bin/vim

# until https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=883086 is closed
RUN \
  cd /usr/share/doc/git/contrib/diff-highlight && make

RUN printf "#!/bin/sh\n\
useradd -M -s /bin/zsh $username\n\
install -d -o $username -g $username -m 0700 /home/$username \n\
echo $mailname > /etc/mailname \n\
echo machine $yadm_host > /home/$username/.netrc \n\
echo login $yadm_user >> /home/$username/.netrc \n\
echo password $yadm_pass >> /home/$username/.netrc \n\
su - $username -c 'yadm clone $repository --bootstrap' \n\
su - $username -c 'yadm config local.class docker' \n\
rm -f /usr/local/preinit/98-run-yadm \n\
exit 0 \n\
\n" \
>> /usr/local/preinit/98-run-yadm

RUN \
  chmod 755 /usr/local/preinit/98-run-yadm
