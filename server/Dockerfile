# Author: Per
# Description: Custom Ollama server image pre-loaded with the Nightmare model

FROM ollama/ollama:latest

WORKDIR /model

COPY entrypoint.sh .
RUN chmod +x /model/entrypoint.sh

COPY Modelfile .

ENTRYPOINT [ "/model/entrypoint.sh" ]