run-local:
	docker build -t webhookdb-docs:latest --progress=plain .
	docker run --rm \
      -p 19040:19040 \
      -v ${PWD}:/app \
      webhookdb-docs:latest
