#!/usr/bin/bash

ollama serve
ollama create -f Modelfile nightmare:latest
ollama run nightmare:latest