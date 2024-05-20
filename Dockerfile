ARG BASE_IMAGE_AWS_CLI
FROM $BASE_IMAGE_AWS_CLI

ARG TERRAFORM_VERSION

LABEL terraform.version=${TERRAFORM_VERSION}
# terraform https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
RUN \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip && \
    unzip terraform.zip && \
    rm -f terraform.zip && \
    mv terraform /usr/local/bin/

ENTRYPOINT ["/assets/scripts/entrypoint.sh", "terraform"]
