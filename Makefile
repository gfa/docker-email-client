run:
	-docker run -d --cap-drop=MKNOD \
		-v $$HOME/mail:$${HOME}/mail:rw \
		-v $$HOME/mail/gnupg:$${HOME}/.gnupg:rw \
		-v $$HOME/mail/pass:$${HOME}/.password-store:rw \
		-v $$HOME/mail/nullmailer/queue:/var/lib/nullmailer:rw \
		-v $$HOME/mail/nullmailer/etc:/etc/nullmailer:ro \
		-v $$HOME/tmp:$${HOME}/tmp:rw \
		-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
		--tmpfs /run:size=100M --tmpfs /run/lock:size=100M \
		--stop-signal=SIGRTMIN+3 --env DEBBASE_NO_STARTUP_APT=y \
		--env DEBBASE_SSH=enabled \
		-p 127.0.0.1:9022:22/tcp \
		--name neomutt_mua neomutt_mua
	-docker start neomutt_mua

console:
	docker exec -ti --user $$USER neomutt_mua zsh

build:
	docker build -t neomutt_mua \
		--build-arg username=$$USER \
		--build-arg repository=$$YADM_REPO --build-arg yadm_user=$$YADM_USER \
		--build-arg yadm_pass=$$YADM_PASS --build-arg yadm_host=$$YADM_HOST \
		--build-arg mailname=$$MAILNAME \
		.

clean:
	docker stop neomutt_mua || true
	docker rm neomutt_mua || true
	docker image rm neomutt_mua || true

stop:
	docker stop neomutt_mua

rm: stop
	docker rm neomutt_mua

.PHONY: run console build clean stop rm
