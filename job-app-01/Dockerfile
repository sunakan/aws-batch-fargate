FROM debian:buster-slim as builder
RUN apt-get update \
  && apt-get install -y curl unzip

WORKDIR /tmp/
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip

FROM debian:buster-slim as release
WORKDIR /var/local/app/
COPY --from=builder /tmp/aws/ /var/local/app/aws/
RUN ./aws/install \
  && rm -rf ./aws/ \
  && apt-get update \
  && apt-get install -y jq \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
COPY ./main.sh ./main.sh

ENTRYPOINT ["/bin/bash", "./main.sh"]
