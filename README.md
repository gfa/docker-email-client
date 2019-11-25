## MUA container

This repo contains the bits required to run (neo)mutt in a Docker container with some helpful tools.

The way each person manages its email workflow is unique, so most likely this won't be useful to you, at most it can be taken as an starting point.

### Dockerfile

I base my container on the excellent work of `jgoerzen` which provides a sane Debian image. Then I install the tools _I_ use to manage my email.

- neomutt
- neovim[plugins]
- direnv
- yadm[envtpl]
- nullmailer as mta
- bsd-mailx
- vdirsyncer
- notmuch
- pass
- muttdown
- isync
